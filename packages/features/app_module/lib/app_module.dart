library app_module;

import 'package:flutter_modular/flutter_modular.dart';
import 'package:splash_module/splash_module.dart';

class AppModule extends Module {
  @override
  void routes(r) {
    r.module(
      '/',
      module: SplashModule(),
    );
  }
}
