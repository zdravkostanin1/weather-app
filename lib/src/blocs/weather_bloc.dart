import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/src/models/weather_data.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) {});
    on<FetchWeatherByLocation>(_onFetchWeatherByLocation);
    on<FetchWeatherByCity>(_onFetchWeatherByCity);
    on<FetchCitySuggestions>(_onFetchCitySuggestions);
  }

  Future<void> _onFetchWeatherByLocation(FetchWeatherByLocation event, Emitter<WeatherState> emit) async {
    Position position = await LocationService.getCurrentLocation();
    double latitude = position.latitude;
    double longitude = position.longitude;

    emit(WeatherFetched(weatherData: await WeatherService.getWeather(latitude, longitude), fiveDayForecast: await WeatherService.get5DayForecast(latitude, longitude)));
  }

  FutureOr<void> _onFetchWeatherByCity(FetchWeatherByCity event, Emitter<WeatherState> emit) async {
    final newWeatherData = await WeatherService.getWeatherByCity(event.cityName);

    emit(WeatherFetched(weatherData: await WeatherService.getWeatherByCity(event.cityName), fiveDayForecast: await WeatherService.get5DayForecast(newWeatherData.latitude, newWeatherData.longitude)));
  }

  FutureOr<void> _onFetchCitySuggestions(FetchCitySuggestions event, Emitter<WeatherState> emit) async {
    /// If the query is empty, return an empty list of suggestions. E.g. user has cleared the search and has not selected a city...
    if (event.query == null || event.query!.isEmpty) {
      emit(WeatherFetched(weatherData: state.weatherData, citySuggestions: const [], fiveDayForecast: state.fiveDayForecast));
    } else {
      final suggestions = await WeatherService.getCitySuggestions(event.query);

      emit(WeatherFetched(weatherData: state.weatherData, citySuggestions: suggestions, fiveDayForecast: state.fiveDayForecast));
    }
  }
}
