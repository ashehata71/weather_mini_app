import 'package:feature_weather/data/data_sources/local_data_source.dart';
import 'package:feature_weather/data/data_sources/remote_data_source.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([
  MockSpec<IWeatherRemoteDataSource>(),
  MockSpec<IWeatherLocalDataSource>(),
])
void main() {}