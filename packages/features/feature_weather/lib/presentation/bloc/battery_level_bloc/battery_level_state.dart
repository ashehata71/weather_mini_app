part of 'battery_level_bloc.dart';

@immutable
sealed class BatteryLevelState {}

final class BatteryLevelInitial extends BatteryLevelState {}

class FetchedBatteryLevelState extends BatteryLevelState {
  final String batteryLevel;

  FetchedBatteryLevelState({required this.batteryLevel});
}
