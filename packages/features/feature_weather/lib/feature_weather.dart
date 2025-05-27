library feature_weather;

import 'package:core/di/service_locator.dart';
import 'package:core/native_service_handler/native_service_handler.dart';
import 'package:core/network_manager/network_handler.dart';
import 'package:feature_weather/data/data_sources/local_data_source_impl.dart';
import 'package:feature_weather/data/data_sources/remote_data_source.dart';
import 'package:feature_weather/data/repositories/weather_repository_impl.dart';
import 'package:feature_weather/domain/repositories/weather_repository.dart';
import 'package:feature_weather/feature_weather_constants.dart';
import 'package:feature_weather/presentation/bloc/battery_level_bloc/battery_level_bloc.dart';
import 'package:feature_weather/presentation/bloc/weather_bloc/weather_bloc.dart';
import 'package:feature_weather/presentation/screens/weather_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/data_sources/local_data_source.dart';
import 'data/data_sources/remote_data_source_impl.dart';

class FeatureWeather extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton<IWeatherLocalDataSource>(
      () => WeatherLocalDataSourceImpl(
        sharedPreferences: getIt<SharedPreferences>(),
      ),
    );
    i.addLazySingleton<IWeatherRemoteDataSource>(
      () => WeatherRemoteDataSourceImpl(
        networkHandler: getIt<INetworkHandler>(),
        apiKey: FeatureWeatherConstants.apiKey,
      ),
    );
    i.addLazySingleton<IWeatherRepository>(
      () => WeatherRepositoryImpl(
        remoteDataSource: Modular.get<IWeatherRemoteDataSource>(),
        localDataSource: Modular.get<IWeatherLocalDataSource>(),
      ),
    );

    i.add<WeatherBloc>(
      () => WeatherBloc(weatherRepository: Modular.get<IWeatherRepository>()),
    );
    i.add<BatteryLevelBloc>(
      () => BatteryLevelBloc(serviceHandler: getIt<IServiceHandler>()),
    );
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => MultiBlocProvider(
        providers: [
          BlocProvider<WeatherBloc>(
            create: (context) => Modular.get<WeatherBloc>(),
          ),
          BlocProvider<BatteryLevelBloc>(
            create: (context) => Modular.get<BatteryLevelBloc>(),
          ),
        ],
        child: const WeatherScreen(),
      ),
    );
  }
}
