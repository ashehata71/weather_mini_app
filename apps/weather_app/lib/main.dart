import 'dart:async';

import 'package:app_module/app_module.dart';
import 'package:core/di/service_locator.dart';
import 'package:core/shared_logic/app_theme/app_theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  final themeCubit = getIt<AppThemeCubit>();
  await themeCubit.initTheme(); // load saved theme
  runApp(ModularApp(
    module: AppModule(),
    child: AppMaterial(themeCubit),
  ));
}

class AppMaterial extends StatelessWidget {
  final AppThemeCubit themeCubit;

  const AppMaterial(this.themeCubit, {super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppThemeCubit>.value(
      value: themeCubit,
      child: BlocBuilder<AppThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: "Weather App",
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            routerConfig: Modular.routerConfig,
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
          );
        },
      ),
    ); //added by extension
  }
}
