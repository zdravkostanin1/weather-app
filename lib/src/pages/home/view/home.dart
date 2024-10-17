import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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

  getWeather() {
    WeatherService.getWeather().then((value) {
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '${weatherData?.cityName}',
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
                        height: 200.0,
                      ),
                      const SizedBox(height: 20.0),
                      Column(
                        children: [
                          Text(
                            '${weatherData?.temp.toStringAsFixed(2)}°C',
                            style: GoogleFonts.roboto(
                              fontSize: 60.0,
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
                const SizedBox(height: 20.0),
                RoundedContainer(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '${weatherData?.temp.toStringAsFixed(2)}°C',
                                style: GoogleFonts.roboto(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Temp',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: Colors.black,
                            thickness: 1.0,
                          ),
                          Column(
                            children: [
                              Text(
                                '${weatherData?.wind} km/h',
                                style: GoogleFonts.roboto(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Wind',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: Colors.black,
                            thickness: 1.0,
                          ),
                          Column(
                            children: [
                              Text(
                                '${weatherData?.humidity}%',
                                style: GoogleFonts.roboto(
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Humidity',
                                style: GoogleFonts.roboto(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
    );
  }
}
