import '../../domain/models/weather_model.dart';
import '../../domain/repositories/weather_repository_interface.dart';
import '../datasources/weather_remote_data_source.dart';

/// Concrete implementation of [IWeatherRepository].
/// Interacts with the remote data source and maps raw responses into domain entities.
class WeatherRepository implements IWeatherRepository {
  final IWeatherRemoteDataSource remoteDataSource;

  WeatherRepository({required this.remoteDataSource});

  @override
  Future<WeatherModel> getCurrentWeather(String cityName,
      {String units = 'metric'}) async {
    final rawJson =
        await remoteDataSource.fetchCurrentWeather(cityName, units: units);
    return WeatherModel.fromJson(rawJson);
  }
}
