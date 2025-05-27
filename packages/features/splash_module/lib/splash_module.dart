library splash_module;

import 'package:feature_weather/feature_weather.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:splash_module/presentation/screens/splash_screen.dart';

class SplashModule extends Module {
  @override
  void routes(r) {
    r.child(
      '/',
      child: (_) => const SplashScreen(),
    );
    r.module(
      '/feature_weather',
      module: FeatureWeather(),
    );
  }
}
