import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Samarth eGov'**
  String get welcomeTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Employee Login'**
  String get loginTitle;

  /// No description provided for @employeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee ID'**
  String get employeeId;

  /// No description provided for @employeeIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Employee ID is required'**
  String get employeeIdRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @leaves.
  ///
  /// In en, this message translates to:
  /// **'Leaves'**
  String get leaves;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी'**
  String get hindi;

  /// No description provided for @serviceBook.
  ///
  /// In en, this message translates to:
  /// **'Service Book'**
  String get serviceBook;

  /// No description provided for @appraisals.
  ///
  /// In en, this message translates to:
  /// **'Appraisals'**
  String get appraisals;

  /// No description provided for @grievances.
  ///
  /// In en, this message translates to:
  /// **'Grievances'**
  String get grievances;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or employee ID to receive password reset instructions'**
  String get forgotPasswordSubtitle;

  /// No description provided for @emailOrEmployeeId.
  ///
  /// In en, this message translates to:
  /// **'Email or Employee ID'**
  String get emailOrEmployeeId;

  /// No description provided for @emailOrIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or employee ID'**
  String get emailOrIdRequired;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset instructions sent to your email'**
  String get passwordResetSent;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @dashboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your employee portal dashboard'**
  String get dashboardSubtitle;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @applyLeave.
  ///
  /// In en, this message translates to:
  /// **'Apply Leave'**
  String get applyLeave;

  /// No description provided for @viewSalary.
  ///
  /// In en, this message translates to:
  /// **'View Salary'**
  String get viewSalary;

  /// No description provided for @fileGrievance.
  ///
  /// In en, this message translates to:
  /// **'File Grievance'**
  String get fileGrievance;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @leaveSummary.
  ///
  /// In en, this message translates to:
  /// **'Leave Summary'**
  String get leaveSummary;

  /// No description provided for @casualLeave.
  ///
  /// In en, this message translates to:
  /// **'Casual Leave'**
  String get casualLeave;

  /// No description provided for @sickLeave.
  ///
  /// In en, this message translates to:
  /// **'Sick Leave'**
  String get sickLeave;

  /// No description provided for @earnedLeave.
  ///
  /// In en, this message translates to:
  /// **'Earned Leave'**
  String get earnedLeave;

  /// No description provided for @employeeServices.
  ///
  /// In en, this message translates to:
  /// **'Employee Services'**
  String get employeeServices;

  /// No description provided for @loanAdvances.
  ///
  /// In en, this message translates to:
  /// **'Loan & Advances'**
  String get loanAdvances;

  /// No description provided for @pension.
  ///
  /// In en, this message translates to:
  /// **'Pension'**
  String get pension;

  /// No description provided for @circulars.
  ///
  /// In en, this message translates to:
  /// **'Circulars'**
  String get circulars;

  /// No description provided for @holidays.
  ///
  /// In en, this message translates to:
  /// **'Holidays'**
  String get holidays;

  /// No description provided for @pendingGrievanceAlert.
  ///
  /// In en, this message translates to:
  /// **'You have a pending grievance'**
  String get pendingGrievanceAlert;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @leaveType.
  ///
  /// In en, this message translates to:
  /// **'Leave Type'**
  String get leaveType;

  /// No description provided for @leaveTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Leave Type is required'**
  String get leaveTypeRequired;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @fromDateRequired.
  ///
  /// In en, this message translates to:
  /// **'From Date is required'**
  String get fromDateRequired;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @toDateRequired.
  ///
  /// In en, this message translates to:
  /// **'To Date is required'**
  String get toDateRequired;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Reason is required'**
  String get reasonRequired;

  /// No description provided for @leaveApplicationSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Leave application submitted successfully'**
  String get leaveApplicationSubmitted;

  /// No description provided for @leaveHistory.
  ///
  /// In en, this message translates to:
  /// **'Leave History'**
  String get leaveHistory;

  /// No description provided for @noLeaveHistory.
  ///
  /// In en, this message translates to:
  /// **'No Leave History'**
  String get noLeaveHistory;

  /// No description provided for @leaveDetails.
  ///
  /// In en, this message translates to:
  /// **'Leave Details'**
  String get leaveDetails;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @leaveBalanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Balance'**
  String get leaveBalanceTitle;

  /// No description provided for @leaveHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave History'**
  String get leaveHistoryTitle;

  /// No description provided for @leaveStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Status'**
  String get leaveStatusTitle;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @noPendingLeaves.
  ///
  /// In en, this message translates to:
  /// **'No pending leave applications'**
  String get noPendingLeaves;

  /// No description provided for @viewHistory.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistory;

  /// No description provided for @viewStatus.
  ///
  /// In en, this message translates to:
  /// **'View Status'**
  String get viewStatus;

  /// No description provided for @selectLeaveType.
  ///
  /// In en, this message translates to:
  /// **'Please select a leave type'**
  String get selectLeaveType;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get selectDate;

  /// No description provided for @enterReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter a reason'**
  String get enterReason;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillAllFields;

  /// No description provided for @clearForm.
  ///
  /// In en, this message translates to:
  /// **'Clear Form'**
  String get clearForm;

  /// No description provided for @confirmExit.
  ///
  /// In en, this message translates to:
  /// **'Confirm Exit'**
  String get confirmExit;

  /// No description provided for @unsavedChangesWarning.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to discard them?'**
  String get unsavedChangesWarning;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @toDateBeforeFromDate.
  ///
  /// In en, this message translates to:
  /// **'To date must be after from date'**
  String get toDateBeforeFromDate;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @sendLink.
  ///
  /// In en, this message translates to:
  /// **'Send Link'**
  String get sendLink;

  /// No description provided for @linkVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get linkVerificationTitle;

  /// Text shown when a verification link is sent
  ///
  /// In en, this message translates to:
  /// **'A verification link has been sent to {email}'**
  String linkSentTo(Object email);

  /// No description provided for @checkEmailInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please check your email and click the link to sign in.'**
  String get checkEmailInstructions;

  /// No description provided for @resendLink.
  ///
  /// In en, this message translates to:
  /// **'Resend Link'**
  String get resendLink;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Select Organization'**
  String get organization;

  /// No description provided for @organizationRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select an organization'**
  String get organizationRequired;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get emailInvalid;

  /// Text showing the remaining time for email verification
  ///
  /// In en, this message translates to:
  /// **'Time remaining: {time}'**
  String verificationTimeRemaining(Object time);

  /// Text shown when the verification link expires
  ///
  /// In en, this message translates to:
  /// **'Verification link has expired. Please resend.'**
  String get verificationExpired;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
