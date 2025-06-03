import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<String> login(String employeeId, String password);
  Future<void> sendPasswordReset(String emailOrId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<String> login(String employeeId, String password) async {
    // Implement your actual API call here
    // This is just a mock implementation
    await Future.delayed(const Duration(seconds: 1));
    return 'mock_token';
  }

  @override
  Future<void> sendPasswordReset(String emailOrId) async {
    // Implement your actual API call here
    // This is just a mock implementation
    await Future.delayed(const Duration(seconds: 1));
  }
}