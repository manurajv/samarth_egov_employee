import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile(ProfileModel profile);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get(
        'https://user1749627892472.requestly.tech/delhi-university/employee/profile',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        if (response.data == null) {
          throw ServerException(
            message: 'Response data is null',
            statusCode: response.statusCode,
          );
        }

        final profileData = response.data as Map<String, dynamic>;

        return ProfileModel.fromJson(
          profileData,
          fullName: profileData['fullName'] ?? '',
          designation: profileData['designation'] ?? '',
          department: profileData['department'] ?? '',
        );
      } else {
        throw ServerException(
          message: 'Failed to load profile: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}, Response: ${e.response?.data}');
      throw ServerException(
        message: e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      print('Unexpected error: $e');
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: null,
      );
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      final response = await dio.put(
        'http://10.0.2.2:3000/profile',
        data: profile.toJson(),
      );
      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Failed to update profile: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      print('DioException in updateProfile: ${e.message}, Response: ${e.response?.data}');
      throw ServerException(
        message: e.message ?? 'Failed to update profile',
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      print('Unexpected error in updateProfile: $e');
      throw ServerException(
        message: 'Unexpected error: $e',
        statusCode: null,
      );
    }
  }
}