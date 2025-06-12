class ApiEndpoints {
  // static const String baseUrl = 'http://10.0.2.2:3000';
  static const String baseUrl = 'https://user1749627892472.requestly.tech';

  static String getUniversities() => '/universities';

  static String getUser(String organizationSlug, String email) =>
      '/$organizationSlug/users?email=$email';

  static String sendSignInLink(String organizationSlug) =>
      '/$organizationSlug/auth/send-link';

  static String verifySignInLink(String organizationSlug, String email) =>
      '/$organizationSlug/auth/verify-link';
}

