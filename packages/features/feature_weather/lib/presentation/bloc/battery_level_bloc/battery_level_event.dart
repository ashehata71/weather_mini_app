part of 'battery_level_bloc.dart';

@immutable
sealed class BatteryLevelEvent {}

class FetchBatteryLevelEvent extends BatteryLevelEvent{}
