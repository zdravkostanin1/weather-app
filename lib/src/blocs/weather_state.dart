part of 'weather_bloc.dart';

sealed class WeatherState extends Equatable {
  final WeatherData? weatherData;
  final double? latitude;
  final double? longitude;
  final List<WeatherData>? weekForecast;
  final List<Map<String, dynamic>>? citySuggestions;
  final bool? isLoadingSuggestions;

  const WeatherState({
    this.weatherData,
    this.latitude,
    this.longitude,
    this.weekForecast,
    this.citySuggestions,
    this.isLoadingSuggestions,
  });
}

final class WeatherInitial extends WeatherState {

  @override
  List<Object> get props => [];
}

final class WeatherFetched extends WeatherState {

  const WeatherFetched({required WeatherData super.weatherData, super.weekForecast});

  @override
  List<Object?> get props => [weatherData, weekForecast];
}
