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

  getWeather() async {
    Position position = await LocationService.getCurrentLocation();
    latitude = position.latitude;
    longitude = position.longitude;
    WeatherService.getWeather(latitude, longitude).then((value) {
      setState(() {
        weatherData = value;
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
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.dark_mode,
              color: Colors.black,
              size: 30.0,
            ),
            onPressed: () {},
          )
        ],
        leading: const Icon(
          Icons.search,
          color: Colors.black,
          size: 30.0,
        ),
      ),
      body: weatherData == null
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.black,
            ))
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
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.thermostat_outlined,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                  Text(
                                    '${weatherData?.temp.toStringAsFixed(2)}°C',
                                    style: GoogleFonts.roboto(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Temp',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.white,
                              thickness: 2.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.waves_outlined,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                  Text(
                                    '${weatherData?.wind} km/h',
                                    style: GoogleFonts.roboto(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Wind',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(
                              color: Colors.white,
                              thickness: 2.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.water_drop_outlined,
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                  Text(
                                    '${weatherData?.humidity}%',
                                    style: GoogleFonts.roboto(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Humidity',
                                    style: GoogleFonts.roboto(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white,
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
                    future: WeatherService.get5DayForecast(latitude, longitude),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                margin: const EdgeInsets.only(left: 20.0),
                                decoration: BoxDecoration(
                                  color: Colors.black,
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
                                        color: Colors.white,
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
                                        color: Colors.white,
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
    );
  }
}
