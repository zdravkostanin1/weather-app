import 'package:intl/intl.dart';

class WeatherData {
  final String? cityName;
  final double temp;
  final String main;
  final int? humidity;
  final String? wind;
  final String? day;
  final String icon;

  WeatherData({
    this.cityName,
    required this.temp,
    required this.main,
    this.humidity,
    this.wind,
    this.day,
    required this.icon,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    /// Parsing current weather data
    if (json.containsKey('name')) {
      return WeatherData(
        cityName: json['name'],
        temp: json['main']['temp'].toDouble() - 273.15,
        main: json['weather'][0]['main'],
        humidity: json['main']['humidity'],
        wind: json['wind']['speed'].toString(),
        icon: json['weather'][0]['icon'],
      );
    } else {
      /// Parsing forecast data
      DateTime date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
      String day = DateFormat('EEE').format(date); /// e.g., 'Mon', 'Tue'

      return WeatherData(
        temp: json['main']['temp'].toDouble(),
        main: json['weather'][0]['main'],
        icon: json['weather'][0]['icon'],
        day: day,
      );
    }
  }
}