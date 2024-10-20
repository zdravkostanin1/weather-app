import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/blocs/weather_bloc.dart';
import 'package:weather_app/src/pages/home/view/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'A beautiful weather app',
        home: HomeScreen(),
      ),
    );
  }
}
