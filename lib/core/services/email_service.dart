import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:uuid/uuid.dart';

class EmailService {
  final FlutterSecureStorage _storage;
  final String smtpUsername = 'manurajv@gmail.com';
  final String smtpPassword = 'iroe bcrq auul ubzi';
  final String webBaseUrl = 'https://user1749627892472.requestly.tech/delhi-university/auth/verify-link';
  final String appBaseUrl = 'samarth://auth/verify';

  EmailService(this._storage);

  Future<void> sendVerificationEmail(String email, String organizationSlug) async {
    try {
      // Generate a unique token
      final token = const Uuid().v4();
      // Store token with email, organization, and timestamp
      await _storage.write(
        key: 'verification_token_$email',
        value: '$token|$organizationSlug|${DateTime.now().millisecondsSinceEpoch}',
      );

      // Encode query parameters
      final encodedEmail = Uri.encodeQueryComponent(email);
      final encodedToken = Uri.encodeQueryComponent(token);
      final encodedOrg = Uri.encodeQueryComponent(organizationSlug);
      final webLink = '$webBaseUrl?email=$encodedEmail&token=$encodedToken&organization=$encodedOrg';
      final appLink = '$appBaseUrl?email=$encodedEmail&token=$encodedToken&organization=$encodedOrg';

      print('Generated Web Link: $webLink');
      print('Generated App Link: $appLink');

      // Set up SMTP server
      final smtpServer = gmail(smtpUsername, smtpPassword);

      // Create the email message
      final message = Message()
        ..from = Address(smtpUsername, 'Samarth eGov')
        ..recipients.add(email)
        ..subject = 'Verify Your Email - Samarth eGov'
        ..html = '''
          <h3>Email Verification</h3>
          <p>Please click the link below to verify your email address:</p>
          <a href="$webLink">Verify Email</a>
          <p>If the link doesn't work, copy and paste this URL into your browser:</p>
          <p>$webLink</p>
          <p>If you have the Samarth eGov app installed, you can also use this link:</p>
          <p><a href="$appLink">Open in App</a></p>
          '''
        ..text = '''
          Email Verification
          Please copy and paste this URL into your browser to verify your email address:
          $webLink
          If you have the Samarth eGov app installed, use this link:
          $appLink
          ''';

      // Send the email
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
      throw Exception('Failed to send verification email: $e');
    }
  }

  Future<bool> verifyToken(String email, String token, String organizationSlug) async {
    try {
      final storedData = await _storage.read(key: 'verification_token_$email');
      print('Stored Data for $email: $storedData');
      if (storedData == null) return false;
      final parts = storedData.split('|');
      if (parts.length != 3) return false;
      final storedToken = parts[0];
      final storedOrgSlug = parts[1];
      final storedTimestamp = int.parse(parts[2]);
      final elapsed = DateTime.now().millisecondsSinceEpoch - storedTimestamp;
      print('Token Comparison: stored=$storedToken, provided=$token, org=$storedOrgSlug, elapsed=$elapsed');
      if (elapsed > 10 * 60 * 1000) return false; // 10 minutes
      return storedToken == token && storedOrgSlug == organizationSlug;
    } catch (e) {
      print('Error verifying token: $e');
      return false;
    }
  }
}