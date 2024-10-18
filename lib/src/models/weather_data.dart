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
    /// Check if 'dt' field exists to determine if it's daily data
    if (json.containsKey('dt') && json.containsKey('temp') && json['temp'] is Map) {
      /// Parsing daily forecast data
      DateTime date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
      String day = DateFormat('EEE').format(date); // e.g., 'Mon', 'Tue'

      return WeatherData(
        temp: json['temp']['day'].toDouble(),
        main: json['weather'][0]['main'],
        icon: json['weather'][0]['icon'],
        day: day,
      );
    } else {
      /// Parsing current weather data
      return WeatherData(
        cityName: json['name'],
        temp: json['main']['temp'].toDouble() - 273.15,
        main: json['weather'][0]['main'],
        humidity: json['main']['humidity'],
        wind: json['wind']['speed'].toString(),
        icon: json['weather'][0]['icon'],
      );
    }
  }
}