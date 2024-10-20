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
    on<Fetch5DayForecast>(_onFetch5DayForecast);
  }

  Future<void> _onFetchWeatherByLocation(FetchWeatherByLocation event, Emitter<WeatherState> emit) async {
    Position position = await LocationService.getCurrentLocation();
    double latitude = position.latitude;
    double longitude = position.longitude;

    emit(WeatherFetched(weatherData: await WeatherService.getWeather(latitude, longitude), weekForecast: await WeatherService.get5DayForecast(latitude, longitude)));
  }

  FutureOr<void> _onFetchWeatherByCity(FetchWeatherByCity event, Emitter<WeatherState> emit) async {
    emit(WeatherFetched(weatherData: await WeatherService.getWeatherByCity(event.cityName), weekForecast: await WeatherService.get5DayForecast(event.latitude, event.longitude)));
  }

  FutureOr<void> _onFetch5DayForecast(Fetch5DayForecast event, Emitter<WeatherState> emit) {}
}
