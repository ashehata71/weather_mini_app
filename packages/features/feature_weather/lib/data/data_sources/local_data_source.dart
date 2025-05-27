import 'package:core/failure_handler/base_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_weather/data/models/weather_model.dart';

abstract class IWeatherLocalDataSource {
  Future<Either<BaseFailure, WeatherModel?>> getLastWeather(double latitude, double longitude);
  Future<Either<BaseFailure, void>> cacheWeather(WeatherModel weatherToCache);
}
