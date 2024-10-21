part of 'weather_bloc.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();
}

final class FetchWeatherByLocation extends WeatherEvent {
  final double latitude;
  final double longitude;

  const FetchWeatherByLocation(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

final class FetchWeatherByCity extends WeatherEvent {
  final String cityName;
  final double latitude;
  final double longitude;

  const FetchWeatherByCity(this.cityName, this.latitude, this.longitude);

  @override
  List<Object> get props => [cityName];
}

final class Fetch5DayForecast extends WeatherEvent {
  final double latitude;
  final double longitude;

  const Fetch5DayForecast(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

final class FetchCitySuggestions extends WeatherEvent {
  final String query;

  const FetchCitySuggestions(this.query);

  @override
  List<Object> get props => [query];
}
