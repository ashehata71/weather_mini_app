import 'package:flutter/services.dart';

abstract class IServiceHandler {
  Future<String> getBatteryLevel();

  Future<dynamic> invokeMethod(String method, {Map<String, dynamic>? arguments});
}

class ServiceHandler implements IServiceHandler {
  final MethodChannel _platform = const MethodChannel('valu.mini_app.dev');

  @override
  Future<dynamic> invokeMethod(String method, {Map<String, dynamic>? arguments}) async {
    await _platform.invokeMethod(method, arguments);
  }

  @override
  Future<String> getBatteryLevel() async {
    try {
      final int level = await _platform.invokeMethod('getBatteryLevel');
      return '$level%';
    } catch (e) {
      return 'Failed to get battery level.';
    }
  }
}
