import 'package:dio/dio.dart';
import '../../core/network/weather_dio_client.dart';

abstract class IWeatherRemoteDataSource {
  Future<Map<String, dynamic>> fetchCurrentWeather(String cityName,
      {String units = 'metric'});
  Future<Map<String, dynamic>> fetchForecast(String cityName,
      {String units = 'metric'});
}

class WeatherRemoteDataSource implements IWeatherRemoteDataSource {
  final WeatherDioClient client;

  WeatherRemoteDataSource({required this.client});

  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(String cityName,
      {String units = 'metric'}) async {
    try {
      final response = await client.dio.get(
        '/weather',
        queryParameters: {
          'q': cityName,
          'units': units,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> fetchForecast(String cityName,
      {String units = 'metric'}) async {
    try {
      final response = await client.dio.get(
        '/forecast',
        queryParameters: {
          'q': cityName,
          'units': units,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    }
  }

  void _handleDioError(DioException e) {
    if (e.response?.statusCode == 404) {
      throw Exception('CITY_NOT_FOUND');
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      throw Exception('NETWORK_ERROR');
    } else {
      throw Exception('API_ERROR: ${e.response?.statusCode ?? e.message}');
    }
  }
}
