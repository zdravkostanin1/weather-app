import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/src/models/weather_data.dart';

class WeatherService {
  static Future<WeatherData> getWeather() async {
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=Sofia&appid=af234654c5eb2a7d6365d343588bf317'));

    try {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return WeatherData.fromJson(json);
      } else {
        throw Exception('Failed to get weather');
      }
    } catch (e) {
      throw Exception('An exception occurred: $e');
    }
  }
}