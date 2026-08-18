import 'package:dio/dio.dart';

class DioClient {
  DioClient({required String baseUrl})
    : dio =
          Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 30),
                sendTimeout: const Duration(seconds: 30),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
              ),
            )
            ..interceptors.add(
              LogInterceptor(
                request: true,
                requestBody: true,
                responseBody: true,
                responseHeader: false,
              ),
            );

  final Dio dio;
}
