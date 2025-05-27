import 'package:core/native_service_handler/native_service_handler.dart';
import 'package:core/network_manager/network_handler.dart';
import 'package:core/shared_logic/app_theme/app_theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:theme_handler/theme_handler.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async{
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerLazySingleton<IThemeHandler>(() => ThemeHandler());
  getIt.registerLazySingleton<AppThemeCubit>(() => AppThemeCubit(getIt<IThemeHandler>()));
  getIt.registerLazySingleton<IServiceHandler>(() => ServiceHandler());
  getIt.registerLazySingleton<INetworkHandler>(
      () => NetworkHandler(baseUrl: "https://api.openweathermap.org/data/2.5"));
}
