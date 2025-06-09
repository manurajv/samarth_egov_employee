import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  DioClient(this._dio, this._storage) {
    _dio.options = BaseOptions(
      baseUrl: 'http://10.0.2.2:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('Dio Request: ${options.method} ${options.uri}');
        final token = await _storage.read(key: 'auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        // Remove organization path replacement to avoid conflicts
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Dio Response: ${response.statusCode} ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        print('Dio Error: ${e.message}');
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