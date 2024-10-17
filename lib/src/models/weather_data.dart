class WeatherData {
  final String cityName;
  final double temp;
  final String main;
  final int humidity;
  final String wind;

  WeatherData({required this.cityName, required this.temp, required this.main, required this.humidity, required this.wind});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'],
      temp: json['main']['temp'].toDouble() - 273.15,
      main: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      wind: json['wind']['speed'].toString(),
    );
  }

}