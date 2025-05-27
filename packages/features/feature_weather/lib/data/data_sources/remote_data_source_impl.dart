import 'package:core/failure_handler/base_failure.dart';
import 'package:core/failure_handler/failures.dart';
import 'package:core/network_manager/network_exception.dart';
import 'package:core/network_manager/network_handler.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_weather/data/data_sources/remote_data_source.dart';
import 'package:feature_weather/data/models/weather_model.dart';

class WeatherRemoteDataSourceImpl implements IWeatherRemoteDataSource {
  final INetworkHandler _networkHandler;
  final String _apiKey;

  WeatherRemoteDataSourceImpl({
    required INetworkHandler networkHandler,
    required String apiKey,
  })  : _networkHandler = networkHandler,
        _apiKey = apiKey;

  @override
  Future<Either<BaseFailure, WeatherModel>> getCurrentWeather(double latitude, double longitude) async {
    const path = '/weather';
    final queryParameters = {
      'lat': latitude,
      'lon': longitude,
      'appid': _apiKey,
    };

    try {
      final response = await _networkHandler.get(
        path,
        queryParameters: queryParameters,
      );
      if (response is Map<String, dynamic>) {
        return Right(WeatherModel.fromJson(response));
      } else {
        return const Left(
          ServerFailure(message: 'Failed to parse weather data: Unexpected response format'),
        );
      }
    } on NetworkException catch (e) {
      return Left(ServerFailure(message: 'Network error: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure(
        message: 'An unexpected error occurred while fetching remote weather: ${e.toString()}',
      ));
    }
  }
}
