part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

class GetCurrentWeatherEvent extends WeatherEvent {}
