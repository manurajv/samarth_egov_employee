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

  // Employee-specific endpoints (authenticated)
  static String getEmployeeData(String organizationSlug) => '/$organizationSlug/employee';

  static String getProfile(String organizationSlug) => '/$organizationSlug/employee/profile';

  static String getLeaveBalances(String organizationSlug) => '/$organizationSlug/employee/leaves';

  static String getLeaveHistory(String organizationSlug) => '/$organizationSlug/employee/leave-history';

  static String getLeaveStatuses(String organizationSlug) => '/$organizationSlug/employee/leave-statuses';

  static String getServiceBook(String organizationSlug) => '/$organizationSlug/employee/service-book';

  static String getAppraisals(String organizationSlug) => '/$organizationSlug/employee/appraisals';

  static String getGrievances(String organizationSlug) => '/$organizationSlug/employee/grievances';

  static String getSalarySlips(String organizationSlug) => '/$organizationSlug/employee/salary-slips';
}

