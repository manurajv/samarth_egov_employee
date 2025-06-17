import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../network/dio_client.dart';

class ApiClient {
  final DioClient _dioClient;
  final FlutterSecureStorage _storage;
  final SharedPreferences _prefs;
  String _baseUrl = 'https://user1749627892472.requestly.tech/';

  ApiClient(this._dioClient, this._storage, {required SharedPreferences prefs})
      : _prefs = prefs {
    _initialize();
  }

  Future<void> _initialize() async {
    //final orgSlug = _prefs.getString('orgSlug') ?? 'delhi-university';
    _baseUrl = 'https://user1749627892472.requestly.tech/';
    _dioClient.dio.options.baseUrl = _baseUrl;
    final token = await _storage.read(key: 'auth_token');
    if (token != null) {
      _dioClient.dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<Response> get(String endpoint) async {
    await _initialize();
    try {
      final fullUrl = '$_baseUrl$endpoint';
      print('ApiClient Request: GET $fullUrl');
      final response = await _dioClient.dio.get(endpoint);
      return response;
    } catch (e) {
      print('ApiClient Error: $e (Endpoint: $endpoint)');
      if (e is DioException && e.response?.statusCode == 404) {
        return Response(
          requestOptions: e.requestOptions,
          statusCode: 404,
          data: {'error': 'Resource not found'},
        );
      }
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    await _initialize();
    try {
      final fullUrl = '$_baseUrl$endpoint';
      print('ApiClient Request: POST $fullUrl');
      final response = await _dioClient.dio.post(endpoint, data: data);
      return response;
    } catch (e) {
      print('ApiClient Error: $e (Endpoint: $endpoint)');
      rethrow;
    }
  }
}