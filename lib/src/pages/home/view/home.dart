import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/src/models/weather_data.dart';
import 'package:weather_app/src/pages/home/widgets/rounded_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WeatherData? weatherData;
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLightTheme = true;
  late Future<List<WeatherData>> _weekForecast;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> citySuggestions = [];
  bool isLoadingSuggestions = false;

  /// A method to get the weather based on the user's location and provide a 5-day forecast
  void getWeather() async {
    Position position = await LocationService.getCurrentLocation();

    latitude = position.latitude;
    longitude = position.longitude;
    WeatherService.getWeather(latitude, longitude).then((value) {
      setState(() {
        weatherData = value;
        /// Fetch the 5-day forecast using the user's coordinates
        _weekForecast = WeatherService.get5DayForecast(latitude, longitude);
      });
    });
  }

  /// A method to handle changes in the search bar
  void _onSearchControllerChanged() async {
    final value = _searchController.text;

    if (value.isNotEmpty) {
      setState(() {
        isLoadingSuggestions = true;
      });
      try {
        final suggestions = await WeatherService.getCitySuggestions(value);
        setState(() {
          citySuggestions = suggestions;
          isLoadingSuggestions = false;
        });
      } catch (e) {
        setState(() {
          citySuggestions = [];
          isLoadingSuggestions = false;
        });
      }
    } else {
      setState(() {
        citySuggestions = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getWeather();
    _searchController.addListener(_onSearchControllerChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_onSearchControllerChanged);
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isLightTheme ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Stack(
            children: [
              AppBar(
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      isLightTheme ? Icons.dark_mode : Icons.brightness_6,
                      color: isLightTheme ? Colors.black : Colors.white,
                      size: 40.0,
                    ),
                    onPressed: () {
                      setState(() {
                        isLightTheme = !isLightTheme;
                      });
                    },
                  ),
                ],
              ),
              Positioned(
                top: 60,
                left: 20,
                right: 20,
                bottom: 0,
                child: AnimSearchBar(
                  closeSearchOnSuffixTap: true,
                  textController: _searchController,
                  helpText: 'Search for a city',
                  width: 370,
                  onSuffixTap: () {
                    setState(() {
                      _searchController.clear();
                      citySuggestions.clear();
                    });
                  },
                  onSubmitted: (value) {
                    /// When the user submits, fetch weather for the selected city
                    WeatherService.getWeatherByCity(value).then((weather) {
                      setState(() {
                        /// Get the weather data for the selected city
                        weatherData = weather;
                        latitude = weather.latitude;
                        longitude = weather.longitude;

                        /// Fetch the 5-day forecast using the new city's coordinates
                        _weekForecast = WeatherService.get5DayForecast(latitude, longitude);
                      });
                      setState(() {
                        citySuggestions.clear();

                        /// Clear city suggestions
                        _searchController.clear();

                        /// Clear search bar after fetching weather
                      });
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        body: weatherData == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (citySuggestions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: citySuggestions.length,
                          itemBuilder: (context, index) {
                            final city = citySuggestions[index];
                            return ListTile(
                              title: Center(
                                child: Text(
                                  '${city['name']}, ${city['country']}',
                                ),
                              ),
                              onTap: () {
                                /// Temporarily remove the listener to avoid triggering suggestions again
                                _searchController.removeListener(_onSearchControllerChanged);

                                /// Set the selected city to the search bar text
                                _searchController.text = city['name'];

                                /// Clear suggestions and reattach the listener immediately
                                setState(() {
                                  citySuggestions.clear();
                                });

                                /// Reattach the listener after setting the text
                                _searchController.addListener(_onSearchControllerChanged);

                                /// Fetch weather data asynchronously
                                WeatherService.getWeatherByCity(city['name']).then((weather) {
                                  setState(() {
                                    weatherData = weather;
                                    _weekForecast = WeatherService.get5DayForecast(weather.latitude, weather.longitude);
                                  });
                                });

                                /// Dismiss the search bar's focus after selecting a city
                                final FocusScopeNode currentScope = FocusScope.of(context);

                                if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    Center(
                      child: Text(
                        '📍 ${weatherData?.cityName}',
                        style: GoogleFonts.titilliumWeb(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Center(
                      child: Text(
                        DateFormat('MMMM d, yyyy').format(DateTime.now()),
                        style: GoogleFonts.roboto(
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 50.0,
                        right: 30.0,
                        top: 20.0,
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            WeatherService.getWeatherImage(weatherData?.main),
                            width: 200.0,
                            height: 150.0,
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            children: [
                              Text(
                                '${weatherData?.temp.toStringAsFixed(0)}°C',
                                style: GoogleFonts.roboto(
                                  fontSize: 70.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                weatherData?.main ?? '',
                                style: GoogleFonts.roboto(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    RoundedContainer(
                      decorationColor:
                          isLightTheme ? Colors.black : Colors.white,
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.thermostat_outlined,
                                      color: isLightTheme
                                          ? Colors.white
                                          : Colors.black,
                                      size: 30.0,
                                    ),
                                    Text(
                                      '${weatherData?.temp.toStringAsFixed(2)}°C',
                                      style: GoogleFonts.roboto(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: isLightTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Temp',
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal,
                                        color: isLightTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color:
                                    isLightTheme ? Colors.white : Colors.black,
                                thickness: 2.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.waves_outlined,
                                      color: isLightTheme
                                          ? Colors.white
                                          : Colors.black,
                                      size: 30.0,
                                    ),
                                    Text(
                                      '${weatherData?.wind} km/h',
                                      style: GoogleFonts.roboto(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: isLightTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Wind',
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal,
                                        color: isLightTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VerticalDivider(
                                color:
                                    isLightTheme ? Colors.white : Colors.black,
                                thickness: 2.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.water_drop_outlined,
                                      color: isLightTheme
                                          ? Colors.white
                                          : Colors.black,
                                      size: 30.0,
                                    ),
                                    Text(
                                      '${weatherData?.humidity}%',
                                      style: GoogleFonts.roboto(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: isLightTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      'Humidity',
                                      style: GoogleFonts.roboto(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.normal,
                                        color: isLightTheme
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Weekly forecast',
                          style: GoogleFonts.roboto(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    FutureBuilder<List<WeatherData>>(
                      future: _weekForecast,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          List<WeatherData> forecast = snapshot.data!;
                          return SizedBox(
                            height: 150.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                WeatherData dayWeather = forecast[index];
                                return Container(
                                  width: 100.0,
                                  margin: const EdgeInsets.only(
                                      left: 22.0, right: 22.0),
                                  decoration: BoxDecoration(
                                    color: isLightTheme
                                        ? Colors.black
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        dayWeather.day ?? '',
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: isLightTheme
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      Image.network(
                                        'http://openweathermap.org/img/wn/${dayWeather.icon}@2x.png',
                                        width: 50.0,
                                        height: 50.0,
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        '${dayWeather.temp.toStringAsFixed(1)}°C',
                                        style: GoogleFonts.roboto(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: isLightTheme
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text('No weather data available'),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
      ),
    );
  }
}
