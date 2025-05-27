import 'package:core/failure_handler/base_failure.dart';
import 'package:core/failure_handler/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_weather/data/data_sources/local_data_source.dart';
import 'package:feature_weather/data/data_sources/remote_data_source.dart';
import 'package:feature_weather/data/models/weather_model.dart';
import 'package:feature_weather/domain/repositories/weather_repository.dart';
import 'package:geolocator/geolocator.dart';

class WeatherRepositoryImpl implements IWeatherRepository {
  final IWeatherRemoteDataSource _remoteDataSource;
  final IWeatherLocalDataSource _localDataSource;

  WeatherRepositoryImpl({
    required IWeatherRemoteDataSource remoteDataSource,
    required IWeatherLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<BaseFailure, WeatherModel>> getCurrentWeather() async {
    try {
      Position position = await getCurrentLocation();
      final latitude = position.latitude;
      final longitude = position.longitude;
      final remoteResult = await _remoteDataSource.getCurrentWeather(latitude, longitude);

      return remoteResult.fold(
        (failure) async {
          final localResult = await _localDataSource.getLastWeather(latitude, longitude);
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
