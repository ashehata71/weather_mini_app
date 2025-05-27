import 'dart:async';

import 'package:core/failure_handler/base_failure.dart';
import 'package:feature_weather/data/models/weather_model.dart';
import 'package:feature_weather/domain/repositories/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    on<GetCurrentWeatherEvent>(_getCurrentWeather);
  }

  static WeatherBloc get(BuildContext context) => BlocProvider.of<WeatherBloc>(context);
  final IWeatherRepository weatherRepository;

  FutureOr<void> _getCurrentWeather(GetCurrentWeatherEvent event, Emitter<WeatherState> emit) async {
    emit(GettingCurrentWeatherState());
    final res = await weatherRepository.getCurrentWeather();
    res.fold(
      (BaseFailure failure) {
        emit(
          CurrentWeatherFailureState(message: failure.message),
        );
      },
      (WeatherModel weather) {
        emit(
          LoadedCurrentWeatherState(weather: weather),
        );
      },
    );
  }
}
