import 'package:flutter/material.dart';
import 'package:weather_app/src/pages/home/view/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather app',
      home: HomeScreen(),
    );
  }
}