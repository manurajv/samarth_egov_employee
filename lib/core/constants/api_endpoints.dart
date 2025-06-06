class ApiEndpoints {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static String getUniversities() => '/universities';

  static String getUser(String organizationSlug, String email) =>
      '/$organizationSlug/users?email=$email';

  static String sendOTP(String organizationSlug) => '/$organizationSlug/otps';

  static String verifyOTP(String organizationSlug, String verificationId, String otp) =>
      '/$organizationSlug/otps?verificationId=$verificationId&otp=$otp';
}

