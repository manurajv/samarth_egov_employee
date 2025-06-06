import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/constants/api_endpoints.dart';

class DioClient {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  DioClient(this._dio, this._storage) {
    _dio.options = BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('Dio Request: ${options.method} ${options.uri}');
        final token = await _storage.read(key: 'auth_token');
        final organization = await _storage.read(key: 'organization');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        if (organization != null) {
          options.path = options.path.replaceFirst('{organization}', organization);
        }
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
          throw Exception('API Error: ${e.response?.statusCode} - ${e.response?.data}');
        } else {
          print('Dio Error Details: ${e.error}');
          throw Exception('Network Error: ${e.message}');
        }
      },
    ));
  }

  Dio get dio => _dio;
}