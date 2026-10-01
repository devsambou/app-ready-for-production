import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../constants/app_constants.dart';

/// Configured Dio client for OpenWeatherMap API calls.
/// Injects the appid parameter into query parameters automatically.
class WeatherDioClient {
  final Dio dio;

  WeatherDioClient({Dio? customDio})
      : dio = customDio ??
            Dio(
              BaseOptions(
                baseUrl: AppConstants.openWeatherBaseUrl,
                connectTimeout:
                    const Duration(seconds: AppConstants.connectTimeoutSeconds),
                receiveTimeout:
                    const Duration(seconds: AppConstants.receiveTimeoutSeconds),
                responseType: ResponseType.json,
              ),
            ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
          final updatedQueryParams =
              Map<String, dynamic>.from(options.queryParameters);
          if (!updatedQueryParams.containsKey('appid') && apiKey.isNotEmpty) {
            updatedQueryParams['appid'] = apiKey;
          }
          options.queryParameters = updatedQueryParams;
          return handler.next(options);
        },
      ),
    );
  }
}
