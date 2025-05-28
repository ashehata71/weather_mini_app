import 'package:core/failure_handler/base_failure.dart';
import 'package:core/failure_handler/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_weather/data/data_sources/local_data_source.dart';
import 'package:feature_weather/data/data_sources/remote_data_source.dart';
import 'package:feature_weather/data/models/weather_model.dart';
import 'package:feature_weather/domain/repositories/weather_repository.dart';

class WeatherRepositoryImpl implements IWeatherRepository {
  final IWeatherRemoteDataSource _remoteDataSource;
  final IWeatherLocalDataSource _localDataSource;

  WeatherRepositoryImpl({
    required IWeatherRemoteDataSource remoteDataSource,
    required IWeatherLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<BaseFailure, WeatherModel>> getCurrentWeather(
      {required double lat, required double long}) async {
    try {
      final remoteResult = await _remoteDataSource.getCurrentWeather(lat, long);

      return remoteResult.fold(
        (failure) async {
          final localResult = await _localDataSource.getLastWeather(lat, long);
          return localResult.fold(
            (cacheFailure) {
              return Left(failure);
            },
            (weatherModel) {
              if (weatherModel != null) {
                return Right(weatherModel);
              } else {
                return const Left(
                  NoDataFailure(message: 'Network error and no cached data available.'),
                );
              }
            },
          );
        },
        (weatherModel) async {
          final cacheResult = await _localDataSource.cacheWeather(weatherModel);
          cacheResult.fold(
            (cacheFailure) {},
            (_) {},
          );
          return Right(weatherModel);
        },
      );
    } catch (e) {
      return const Left(
        ServerFailure(message: 'Network error and no cached data available.'),
      );
    }
  }
}
