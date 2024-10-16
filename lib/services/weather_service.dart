import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/src/models/weather_data.dart';

class WeatherService {
  static Future<WeatherData> getWeather(double latitude, double longitude) async {
    final response = await http.get(Uri.parse('http://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=af234654c5eb2a7d6365d343588bf317'));

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

  static Future<List<WeatherData>> get5DayForecast(double latitude, double longitude) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=af234654c5eb2a7d6365d343588bf317'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      List<dynamic> listData = json['list'];

      /// Extract one forecast per day, e.g., at 12:00 PM
      Map<String, WeatherData> dailyForecasts = {};

      for (var item in listData) {
        DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        String date = DateFormat('yyyy-MM-dd').format(dateTime);
        String hour = DateFormat('HH').format(dateTime);

        /// Select forecasts at 12:00 PM
        if (hour == '12' && !dailyForecasts.containsKey(date)) {
          WeatherData weatherData = WeatherData(
            temp: item['main']['temp'].toDouble(),
            main: item['weather'][0]['main'],
            icon: item['weather'][0]['icon'],
            day: DateFormat('EEE').format(dateTime),
          );
          dailyForecasts[date] = weatherData;
        }
      }

      return dailyForecasts.values.toList();
    } else {
      final errorResponse = jsonDecode(response.body);
      final errorMessage = errorResponse['message'] ?? 'Failed to load 5-day forecast';
      throw Exception('Error ${response.statusCode}: $errorMessage');
    }
  }
}