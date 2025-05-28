import 'package:core/failure_handler/base_failure.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_weather/data/models/weather_model.dart';

abstract class IWeatherRepository {
  Future<Either<BaseFailure, WeatherModel>> getCurrentWeather({required double lat, required double long});
}
