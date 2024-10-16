import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather app',
      home: Scaffold(
        appBar: AppBar(
          leading: const Icon(
            Icons.search,
            size: 30.0,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Sofia, BG',
                style: GoogleFonts.titilliumWeb(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5.0),
            Center(
              child: Text(
                'October 16, 2024',
                style: GoogleFonts.roboto(
                  fontSize: 17.0,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Padding(
              padding:
                  const EdgeInsets.only(left: 50.0, right: 30.0, top: 20.0),
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
                        '25°C',
                        style: GoogleFonts.roboto(
                          fontSize: 100.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'SUNNY',
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
            _roundedContainer(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '25°C',
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
                    Column(
                      children: [
                        Text(
                          '30%',
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
                    Column(
                      children: [
                        Text(
                          '10 km/h',
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
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _roundedContainer({required List<Widget>? children}) {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0, right: 28.0, top: 10.0),
      child: Container(
        width: double.infinity,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children ?? [],
        ),
      ),
    );
  }
}
