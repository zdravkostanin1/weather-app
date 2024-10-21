import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/src/blocs/weather_bloc.dart';
import 'package:weather_app/src/models/weather_data.dart';
import 'package:weather_app/src/pages/home/widgets/rounded_container.dart';
import 'package:weather_app/src/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLightTheme = true;
  final TextEditingController _searchController = TextEditingController();

  /// A method to get the weather based on the user's location and provide a 5-day forecast
  void _getWeather() {
    context
        .read<WeatherBloc>()
        .add(FetchWeatherByLocation(latitude, longitude));
  }

  /// A method to search for a city based on the user's input in the search bar
  void _getWeatherForCity() async {
    final value = _searchController.text;

    if (value.isNotEmpty) {
      context.read<WeatherBloc>().add(FetchCitySuggestions(value));
    }
  }

  void _toggleTheme() {
    setState(() {
      isLightTheme = !isLightTheme;
    });
  }

  @override
  void initState() {
    super.initState();
    _getWeather();
    _searchController.addListener(_getWeatherForCity);
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.removeListener(_getWeatherForCity);
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// This is the search bar's width
    double searchBarWidth = MediaQuery.of(context).size.width -
        themeIconWidth -
        iconPadding -
        actionsPadding;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isLightTheme ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return Stack(
                children: [
                  if (state.weatherData != null)
                    AppBar(
                      actions: <Widget>[
                        AnimSearchBar(
                          rtl: true,
                          closeSearchOnSuffixTap: true,
                          textController: _searchController,
                          helpText: 'Search for a city',
                          width: searchBarWidth,
                          onSuffixTap: () {
                            _searchController.clear();
                            context.read<WeatherBloc>().add(
                                FetchCitySuggestions(_searchController.text));
                          },
                          onSubmitted: (value) {
                            latitude = state.weatherData!.latitude;
                            longitude = state.weatherData!.longitude;

                            /// When the user submits, fetch weather for the selected city
                            context.read<WeatherBloc>().add(
                                FetchWeatherByCity(value, latitude, longitude));
                            _searchController.clear();
                          },
                        ),
                        const SizedBox(width: 10.0),
                        ClipOval(
                          child: Material(
                            color: isLightTheme ? Colors.black : Colors.white,
                            child: InkWell(
                              onTap: _toggleTheme,
                              child: SizedBox(
                                width: 47,
                                height: 47,
                                child: Icon(
                                  isLightTheme
                                      ? Icons.dark_mode
                                      : Icons.brightness_6,
                                  color: isLightTheme
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) {
              return Center(
                child: CircularProgressIndicator(
                  color: isLightTheme ? Colors.black : Colors.white,
                ),
              );
            } else if (state is LocationPermissionDeniedState || state is LocationPermissionPermanentlyDeniedState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Image.asset('assets/images/map.png', width: 180.0, height: 180.0)),
                  Text(
                    'Whoops! We need your location to get the weather.',
                    style: GoogleFonts.roboto(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              );
            } else if (state is WeatherFetched) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (state.citySuggestions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: state.citySuggestions.length,
                          itemBuilder: (context, index) {
                            final city = state.citySuggestions[index];
                            return ListTile(
                              title: Center(
                                child: Text(
                                  '${city['name']}, ${city['country']}',
                                ),
                              ),
                              onTap: () {
                                /// Temporarily remove the listener to avoid triggering suggestions again
                                _searchController
                                    .removeListener(_getWeatherForCity);

                                /// Set the selected city to the search bar text
                                _searchController.text = city['name'];

                                /// Reattach the listener after setting the text
                                _searchController
                                    .addListener(_getWeatherForCity);

                                /// Fetch weather for the selected city
                                context.read<WeatherBloc>().add(
                                    FetchWeatherByCity(
                                        city['name'],
                                        state.weatherData!.latitude,
                                        state.weatherData!.longitude));
                                _searchController.clear();

                                /// Dismiss the search bar's focus after selecting a city
                                final FocusScopeNode currentScope =
                                    FocusScope.of(context);

                                if (!currentScope.hasPrimaryFocus &&
                                    currentScope.hasFocus) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }
                              },
                            );
                          },
                        ),
                      ),
                    Center(
                      child: Text(
                        '📍 ${state.weatherData?.cityName}',
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
                            WeatherService.getWeatherImage(
                                state.weatherData?.main),
                            width: 200.0,
                            height: 150.0,
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            children: [
                              Text(
                                '${state.weatherData?.temp.toStringAsFixed(0)}°C',
                                style: GoogleFonts.roboto(
                                  fontSize: 70.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                state.weatherData?.main ?? '',
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
                                      '${state.weatherData?.temp.toStringAsFixed(2)}°C',
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
                                      '${state.weatherData?.wind} km/h',
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
                                      '${state.weatherData?.humidity}%',
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
                    BlocBuilder<WeatherBloc, WeatherState>(
                      builder: (context, state) {
                        if (state is WeatherInitial) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          );
                        } else if (state is WeatherFetched) {
                          List<WeatherData>? forecast = state.fiveDayForecast;
                          return SizedBox(
                            height: 150.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: forecast?.length,
                              itemBuilder: (context, index) {
                                WeatherData? dayWeather = forecast?[index];
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
                                        dayWeather?.day ?? '',
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
                                        'http://openweathermap.org/img/wn/${dayWeather?.icon}@2x.png',
                                        width: 50.0,
                                        height: 50.0,
                                      ),
                                      const SizedBox(height: 10.0),
                                      Text(
                                        '${dayWeather?.temp.toStringAsFixed(1)}°C',
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
              );
            } else {
              return const Center(
                child: Text('No weather data available'),
              );
            }
          },
        ),
      ),
    );
  }
}
