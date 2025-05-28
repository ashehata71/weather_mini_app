import 'dart:convert';
import 'package:core/network_manager/network_exception.dart';
import 'package:dartz/dartz.dart';
import 'package:feature_weather/data/models/weather_model.dart';
import 'package:feature_weather/data/repositories/weather_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'fixtures/fixture_reader.dart';
import 'helpers/test_helpers.mocks.dart';

void main() {
  late MockIWeatherRemoteDataSource mockRemoteDataSource;
  late MockIWeatherLocalDataSource mockLocalDataSource;
  late WeatherRepositoryImpl repository;

  final tWeatherModel =
      WeatherModel.fromJson(jsonDecode(fixture('weather_response.json')) as Map<String, dynamic>);

  const double tLatitude = 45.133;
  const double tLongitude = 7.367;

  setUp(() {
    mockRemoteDataSource = MockIWeatherRemoteDataSource();
    mockLocalDataSource = MockIWeatherLocalDataSource();
    repository = WeatherRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  group('getCurrentWeather', () {
    test('should return weather model from remote data source when call is successful and cache the data',
        () async {
      when(mockRemoteDataSource.getCurrentWeather(any, any)).thenAnswer((_) async => Right(tWeatherModel));
      when(mockLocalDataSource.cacheWeather(any)).thenAnswer((_) async => Future.value(Right(_)));

      // Act
      final result = await repository.getCurrentWeather(lat: tLatitude, long: tLongitude);

      // Assert
      expect(result, equals(Right(tWeatherModel)));

      // Verify that getCurrentWeather was called on the remote data source with correct params
      verify(mockRemoteDataSource.getCurrentWeather(tLatitude, tLongitude));
      // Verify that cacheWeather was called on the local data source with the fetched model
      verify(mockLocalDataSource.cacheWeather(tWeatherModel));
      // Verify that getLastWeather was NOT called on the local data source
      verifyNever(mockLocalDataSource.getLastWeather(any, any));
    });

    test('should return weather model from local data source when remote call fails (NetworkException)',
            () async {
          when(mockRemoteDataSource.getCurrentWeather(any, any))
              .thenThrow(NetworkException(message: 'Failed to connect'));
          // Stub the local data source to return the sample weather model
          when(mockLocalDataSource.getLastWeather(any, any)).thenAnswer((_) async => Right(tWeatherModel));

          // Act
          final result = await repository.getCurrentWeather(lat: tLatitude,long:  tLongitude);

          // Assert
          expect(result.isLeft(), true);

          // Verify that getCurrentWeather was called on the remote data source
          verify(mockRemoteDataSource.getCurrentWeather(tLatitude, tLongitude));
          // Verify that getLastWeather was called on the local data source
          verify(mockLocalDataSource.getLastWeather(tLatitude, tLongitude));
        });
  });
}
