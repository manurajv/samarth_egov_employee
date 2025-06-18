// user_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final SharedPreferences _prefs;
  final FlutterSecureStorage _storage;

  UserService(this._prefs, this._storage);

  Future<String?> getAuthToken() async => await _storage.read(key: 'auth_token');
  Future<String?> getUserId() async => await _storage.read(key: 'user_id');
  String? getOrganizationSlug() => _prefs.getString('orgSlug');
  String? getEmployeeName() => _prefs.getString('employeeName');
  String? getEmail() => _prefs.getString('email');

  Future<Map<String, dynamic>> getUserData() async {
    return {
      'id': await getUserId(),
      'email': getEmail(),
      'name': getEmployeeName(),
      'organizationSlug': getOrganizationSlug(),
    };
  }
}