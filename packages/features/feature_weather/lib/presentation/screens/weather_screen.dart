import 'dart:async';

import 'package:core/di/service_locator.dart';
import 'package:core/shared_logic/app_theme/app_theme_cubit.dart';
import 'package:feature_weather/feature_weather_assets.dart';
import 'package:feature_weather/presentation/bloc/battery_level_bloc/battery_level_bloc.dart';
import 'package:feature_weather/presentation/bloc/weather_bloc/weather_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final themeCubit = getIt<AppThemeCubit>();
  late final WeatherBloc weatherBloc = WeatherBloc.get(context);
  late final BatteryLevelBloc batteryLevelBloc = BatteryLevelBloc.get(context);

  Timer? timer;

  @override
  void initState() {
    super.initState();
    weatherBloc.add(GetCurrentWeatherEvent());
    timer = Timer.periodic(const Duration(seconds: 3), (t) => batteryLevelBloc.add(FetchBatteryLevelEvent()));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final double titleFontSize = screenSize.width * (isPortrait ? 0.08 : 0.05);
    final double tempFontSize = screenSize.width * (isPortrait ? 0.15 : 0.1);
    final double smallFontSize = screenSize.width * (isPortrait ? 0.035 : 0.025);

    return Scaffold(
      body: BlocBuilder<AppThemeCubit, ThemeMode>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  themeCubit.state.index == 1 ? FeatureWeatherAssets.white_bg : FeatureWeatherAssets.dark_bg,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                BlocBuilder<BatteryLevelBloc, BatteryLevelState>(
                  builder: (context, state) {
                    return AppBar(
                      backgroundColor: Colors.transparent,
                      actions: [
                        if (state is FetchedBatteryLevelState)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                                color: Colors.lightGreen, borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              state.batteryLevel,
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                        IconButton(
                          onPressed: () {
                            themeCubit.toggleTheme();
                          },
                          icon: Icon(themeCubit.state.index == 1 ? Icons.dark_mode : Icons.light_mode),
                        )
                      ],
                    );
                  },
                ),
                Expanded(
                  child: BlocConsumer<WeatherBloc, WeatherState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is CurrentWeatherFailureState) {
                        return Center(
                          child: Text(state.message),
                        );
                      }
                      return state is GettingCurrentWeatherState
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : state is LoadedCurrentWeatherState
                              ? SingleChildScrollView(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      // City Name
                                      Text(
                                        state.weather.name,
                                        style: theme.textTheme.headlineLarge!.copyWith(
                                          fontSize: titleFontSize,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),

                                      // Temperature
                                      Text(
                                        '${(state.weather.main.temp - 273.15).toStringAsFixed(1)}°C',
                                        style: theme.textTheme.titleMedium!.copyWith(
                                          fontSize: tempFontSize,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      const SizedBox(height: 5),

                                      // Display Lat/Lon for context
                                      Text(
                                        'Lat: ${state.weather.coord.lat.toStringAsFixed(3)}, Lon: ${state.weather.coord..lon.toStringAsFixed(3)}',
                                        style: theme.textTheme.bodyMedium!.copyWith(
                                          fontSize: smallFontSize,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
