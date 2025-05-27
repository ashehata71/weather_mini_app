import 'package:bloc/bloc.dart';
import 'package:core/native_service_handler/native_service_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'battery_level_event.dart';

part 'battery_level_state.dart';

class BatteryLevelBloc extends Bloc<BatteryLevelEvent, BatteryLevelState> {
  BatteryLevelBloc({required this.serviceHandler}) : super(BatteryLevelInitial()) {
    on<FetchBatteryLevelEvent>((event, emit) async {
      try {
        final String batteryLevel = await serviceHandler.getBatteryLevel();
        emit(FetchedBatteryLevelState(batteryLevel: batteryLevel));
      } catch (e) {}
    });
  }

  static BatteryLevelBloc get(BuildContext context) => BlocProvider.of<BatteryLevelBloc>(context);

  IServiceHandler serviceHandler;
}
