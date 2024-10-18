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

  getWeather() async {
    Position position = await LocationService.getCurrentLocation();

    latitude = position.latitude;
    longitude = position.longitude;
    WeatherService.getWeather(latitude, longitude).then((value) {
      setState(() {
        weatherData = value;
        _weekForecast = WeatherService.get5DayForecast(latitude, longitude);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isLightTheme ? ThemeData.light() : ThemeData.dark(),
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Stack(children: [
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
                // textFieldColor: isLightTheme ? Colors.white : Colors.white,
                textFieldIconColor: isLightTheme ? Colors.white : Colors.black,
                searchIconColor: isLightTheme ? Colors.white : Colors.black,
                color: isLightTheme ? Colors.black : Colors.white,
                helpText: 'Search for a city',
                width: 370,
                textController: TextEditingController(),
                onSuffixTap: () {},
                onSubmitted: (value) {},
              ),
            ),
          ]),
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
                            'assets/images/sunny.png',
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
