import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  DioClient(this._dio, this._storage) {
    _dio.options = BaseOptions(
      baseUrl: 'https://user1749627892472.requestly.tech',
      connectTimeout: const Duration(seconds: 60), // Increased from 10s to 15s
      receiveTimeout: const Duration(seconds: 60), // Increased from 10s to 15s
      headers: {'Content-Type': 'application/json'},
      followRedirects: true,
      maxRedirects: 5,
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'auth_token');
        print('Dio Request: ${options.method} ${options.uri}');
        print('Auth Token: $token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Dio Response: ${response.statusCode} ${response.requestOptions.uri}');
        print('Response Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Dio Error: ${e.message} ${e.requestOptions.uri}');
        if (e.response != null) {
          print('Dio Error Response: ${e.response?.statusCode} ${e.response?.data}');
          return handler.reject(DioException(
            requestOptions: e.requestOptions,
            response: e.response,
            error: Exception('API Error: ${e.response?.statusCode} - ${e.response?.data}'),
          ));
        } else {
          print('Dio Error Details: ${e.error}');
          return handler.reject(DioException(
            requestOptions: e.requestOptions,
            error: Exception('Network Error: ${e.message}'),
          ));
        }
      },
    ));
  }

  Dio get dio => _dio;
}