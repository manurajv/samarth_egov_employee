import 'package:dio/dio.dart';
import '../../../../core/constants/api_endpoints.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, String>> getUniversities();
  Future<String> sendOTP(String email, String organizationSlug); // Updated parameter
  Future<String> verifyOTP(String verificationId, String otp, String email, String organizationSlug); // Updated parameter
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, String>> getUniversities() async {
    try {
      final response = await dio.get(ApiEndpoints.getUniversities());
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return {
          for (var item in data) item['name'] as String: item['slug'] as String,
        };
      }
      throw Exception('Failed to fetch universities: Status ${response.statusCode}');
    } catch (e) {
      print('AuthRemoteDataSourceImpl.getUniversities error: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getUniversityDetails(String slug) async {
    try {
      final response = await dio.get('/$slug');
      if (response.statusCode == 200) {
        return response.data;
      }
      throw Exception('University not found');
    } catch (e) {
      print('getUniversityDetails error: $e');
      rethrow;
    }
  }

  Future<String> sendOTP(String email, String organizationSlug) async {
    try {
      // 1. Get university details
      final universityData = await getUniversityDetails(organizationSlug);

      // 2. Check if user exists
      final users = universityData['users'] as List;
      final userExists = users.any((user) => user['email'] == email);

      if (!userExists) {
        throw Exception('User not found in this university');
      }

      // 3. Generate and send OTP
      final verificationId = 'verif-$organizationSlug-${DateTime.now().millisecondsSinceEpoch}';
      final otp = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();

      // Save OTP (mock implementation)
      universityData['otps'].add({
        'email': email,
        'otp': otp,
        'verificationId': verificationId,
        'createdAt': DateTime.now().toIso8601String(),
        'expiresAt': DateTime.now().add(Duration(minutes: 5)).toIso8601String()
      });

      return verificationId;
    } catch (e) {
      print('SendOTP error: $e');
      rethrow;
    }
  }

  @override
  Future<String> verifyOTP(
      String verificationId,
      String otp,
      String email,
      String organizationSlug,
      ) async {
    try {
      final response = await dio.get(ApiEndpoints.verifyOTP(organizationSlug, verificationId, otp));
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        final otpData = response.data[0];
        final expiresAt = DateTime.parse(otpData['expiresAt']);
        if (expiresAt.isAfter(DateTime.now())) {
          return 'token-$organizationSlug-$email';
        }
        throw Exception('OTP expired');
      }
      throw Exception('Invalid OTP');
    } catch (e) {
      print('AuthRemoteDataSourceImpl.verifyOTP error: $e');
      rethrow;
    }
  }
}