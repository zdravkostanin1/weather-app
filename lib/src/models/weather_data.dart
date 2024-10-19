import 'package:intl/intl.dart';

class WeatherData {
  final String? cityName;
  final double temp;
  final String main;
  final int? humidity;
  final String? wind;
  final String? day;
  final String icon;
  final double longitude;
  final double latitude;

  WeatherData({
    this.cityName,
    required this.temp,
    required this.main,
    this.humidity,
    this.wind,
    this.day,
    required this.icon,
    required this.longitude,
    required this.latitude,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name')) {
      return WeatherData(
        cityName: json['name'],
        temp: json['main']['temp'].toDouble() - 273.15,
        main: json['weather'][0]['main'],
        humidity: json['main']['humidity'],
        wind: json['wind']['speed'].toString(),
        icon: json['weather'][0]['icon'],
        longitude: json['coord']['lon'],
        latitude: json['coord']['lat'],
      );
    } else {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
      String day = DateFormat('EEE').format(date);

      return WeatherData(
        temp: json['main']['temp'].toDouble(),
        main: json['weather'][0]['main'],
        icon: json['weather'][0]['icon'],
        day: day,
        longitude: json['coord']['lon'],
        latitude: json['coord']['lat'],
      );
    }
  }
}