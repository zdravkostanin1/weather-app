part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  final WeatherData? weatherData;
  final double? latitude;
  final double? longitude;
  final List<WeatherData>? fiveDayForecast;
  final List<Map<String, dynamic>>? citySuggestions;

  const WeatherState({
    this.weatherData,
    this.latitude,
    this.longitude,
    this.fiveDayForecast,
    this.citySuggestions,
  });
}

final class WeatherInitial extends WeatherState {

  @override
  List<Object> get props => [];
}

final class WeatherFetched extends WeatherState {

  const WeatherFetched({super.citySuggestions, super.weatherData, super.fiveDayForecast});

  @override
  List<Object?> get props => [weatherData, fiveDayForecast, citySuggestions];
}
