import 'dart:convert';

import 'package:core/failure_handler/base_failure.dart';
import 'package:core/failure_handler/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_weather/data/data_sources/local_data_source.dart';
import 'package:feature_weather/data/models/weather_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherLocalDataSourceImpl implements IWeatherLocalDataSource {
  final SharedPreferences _sharedPreferences;
  static const String _weatherCacheKey = 'last_weather_';

  WeatherLocalDataSourceImpl({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  String _getCacheKey(double latitude, double longitude) =>
      '$_weatherCacheKey${latitude.toStringAsFixed(3)}_${longitude.toStringAsFixed(3)}';

  @override
  Future<Either<BaseFailure, WeatherModel?>> getLastWeather(double latitude, double longitude) async {
    final cacheKey = _getCacheKey(latitude, longitude);
    try {
      final jsonString = _sharedPreferences.getString(cacheKey);
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return Right(WeatherModel.fromJson(jsonMap));
      } else {
        return const Right(null);
      }
    } catch (e) {
      return const Left(CachingFailure(message: 'Failed to parse cached weather data.'));
    }
  }

  @override
  Future<Either<BaseFailure, void>> cacheWeather(WeatherModel weatherToCache) async {
    final cacheKey = _getCacheKey(weatherToCache.coord.lat, weatherToCache.coord.lon);
    try {
      final jsonString = jsonEncode(weatherToCache.toJson());
      final success = await _sharedPreferences.setString(cacheKey, jsonString);
      if (success) {
        return const Right(null);
      } else {
        return const Left(CachingFailure(message: 'Failed to save data to SharedPreferences.'));
      }
    } catch (e) {
      return const Left(CachingFailure(message: 'Failed to cache weather data.'));
    }
  }
}
