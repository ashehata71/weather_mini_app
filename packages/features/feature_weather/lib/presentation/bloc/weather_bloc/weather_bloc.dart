import 'dart:async';

import 'package:core/failure_handler/base_failure.dart';
import 'package:feature_weather/data/models/weather_model.dart';
import 'package:feature_weather/domain/repositories/weather_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial()) {
    on<GetCurrentWeatherEvent>(_getCurrentWeather);
  }

  static WeatherBloc get(BuildContext context) => BlocProvider.of<WeatherBloc>(context);
  final IWeatherRepository weatherRepository;

  FutureOr<void> _getCurrentWeather(GetCurrentWeatherEvent event, Emitter<WeatherState> emit) async {
    try {
      emit(GettingCurrentWeatherState());
      Position position = await getCurrentLocation();
      final res = await weatherRepository.getCurrentWeather(lat: position.latitude, long: position.longitude);
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
    }catch(e){
      emit(
        CurrentWeatherFailureState(message: 'There was a problem getting the current location.'),
      );
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
