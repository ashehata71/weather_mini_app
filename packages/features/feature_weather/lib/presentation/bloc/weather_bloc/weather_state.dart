part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

class GettingCurrentWeatherState extends WeatherState {}

class LoadedCurrentWeatherState extends WeatherState {
  final WeatherModel weather;

  LoadedCurrentWeatherState({required this.weather});
}

class CurrentWeatherFailureState extends WeatherState {
  final String message;

  CurrentWeatherFailureState({required this.message});
}
