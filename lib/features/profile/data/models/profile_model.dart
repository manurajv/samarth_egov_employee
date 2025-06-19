import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  final String email;
  final String employeeId;
  final String fullName;
  final String designation;
  final String department;
  final String dob;
  final String gender;
  final String bloodGroup;
  final String category;
  final String religion;
  final String aadharNumber;
  final String joiningDate;
  final String currentPosting;
  final String employeeType;
  final String payLevel;
  final String currentBasicPay;
  final String maritalStatus;
  final String spouseName;
  final int children;
  final String fatherName;
  final String motherName;
  final String presentAddress;
  final String permanentAddress;
  final String emergencyContact;
  final String bankName;
  final String accountNumber;
  final String accountType;
  final String branch;
  final String ifscCode;

  ProfileModel({
    required this.email,
    required this.employeeId,
    required this.fullName,
    required this.designation,
    required this.department,
    required this.dob,
    required this.gender,
    required this.bloodGroup,
    required this.category,
    required this.religion,
    required this.aadharNumber,
    required this.joiningDate,
    required this.currentPosting,
    required this.employeeType,
    required this.payLevel,
    required this.currentBasicPay,
    required this.maritalStatus,
    required this.spouseName,
    required this.children,
    required this.fatherName,
    required this.motherName,
    required this.presentAddress,
    required this.permanentAddress,
    required this.emergencyContact,
    required this.bankName,
    required this.accountNumber,
    required this.accountType,
    required this.branch,
    required this.ifscCode,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final profileData = json['profile'] ?? json;
    return ProfileModel(
      email: profileData['email']?.toString() ?? '',
      employeeId: profileData['employeeId']?.toString() ?? '',
      fullName: profileData['fullName']?.toString() ?? '',
      designation: profileData['designation']?.toString() ?? '',
      department: profileData['department']?.toString() ?? '',
      dob: profileData['personal']?['dob']?.toString() ?? '',
      gender: profileData['personal']?['gender']?.toString() ?? '',
      bloodGroup: profileData['personal']?['bloodGroup']?.toString() ?? '',
      category: profileData['personal']?['category']?.toString() ?? '',
      religion: profileData['personal']?['religion']?.toString() ?? '',
      aadharNumber: profileData['personal']?['aadharNumber']?.toString() ?? '',
      joiningDate: profileData['service']?['joiningDate']?.toString() ?? '',
      currentPosting: profileData['service']?['currentPosting']?.toString() ?? '',
      employeeType: profileData['service']?['employeeType']?.toString() ?? '',
      payLevel: profileData['service']?['payLevel']?.toString() ?? '',
      currentBasicPay: profileData['service']?['currentBasicPay']?.toString() ?? '',
      maritalStatus: profileData['family']?['maritalStatus']?.toString() ?? '',
      spouseName: profileData['family']?['spouseName']?.toString() ?? '',
      children: (profileData['family']?['children'] as num?)?.toInt() ?? 0,
      fatherName: profileData['family']?['fatherName']?.toString() ?? '',
      motherName: profileData['family']?['motherName']?.toString() ?? '',
      presentAddress: profileData['address']?['presentAddress']?.toString() ?? '',
      permanentAddress: profileData['address']?['permanentAddress']?.toString() ?? '',
      emergencyContact: profileData['address']?['emergencyContact']?.toString() ?? '',
      bankName: profileData['bank']?['bankName']?.toString() ?? '',
      accountNumber: profileData['bank']?['accountNumber']?.toString() ?? '',
      accountType: profileData['bank']?['accountType']?.toString() ?? '',
      branch: profileData['bank']?['branch']?.toString() ?? '',
      ifscCode: profileData['bank']?['ifscCode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile': {
        'email': email,
        'employeeId': employeeId,
        'fullName': fullName,
        'designation': designation,
        'department': department,
        'personal': {
          'dob': dob,
          'gender': gender,
          'bloodGroup': bloodGroup,
          'category': category,
          'religion': religion,
          'aadharNumber': aadharNumber,
        },
        'service': {
          'joiningDate': joiningDate,
          'currentPosting': currentPosting,
          'employeeType': employeeType,
          'payLevel': payLevel,
          'currentBasicPay': currentBasicPay,
        },
        'family': {
          'maritalStatus': maritalStatus,
          'spouseName': spouseName,
          'children': children,
          'fatherName': fatherName,
          'motherName': motherName,
        },
        'address': {
          'presentAddress': presentAddress,
          'permanentAddress': permanentAddress,
          'emergencyContact': emergencyContact,
        },
        'bank': {
          'bankName': bankName,
          'accountNumber': accountNumber,
          'accountType': accountType,
          'branch': branch,
          'ifscCode': ifscCode,
        },
      },
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      email: email,
      employeeId: employeeId,
      fullName: fullName,
      designation: designation,
      department: department,
      dob: dob,
      gender: gender,
      bloodGroup: bloodGroup,
      category: category,
      religion: religion,
      aadharNumber: aadharNumber,
      joiningDate: joiningDate,
      currentPosting: currentPosting,
      employeeType: employeeType,
      payLevel: payLevel,
      currentBasicPay: currentBasicPay,
      maritalStatus: maritalStatus,
      spouseName: spouseName,
      children: children,
      fatherName: fatherName,
      motherName: motherName,
      presentAddress: presentAddress,
      permanentAddress: permanentAddress,
      emergencyContact: emergencyContact,
      bankName: bankName,
      accountNumber: accountNumber,
      accountType: accountType,
      branch: branch,
      ifscCode: ifscCode,
    );
  }

  static ProfileModel fromEntity(ProfileEntity entity) {
    return ProfileModel(
      email: entity.email,
      employeeId: entity.employeeId,
      fullName: entity.fullName,
      designation: entity.designation,
      department: entity.department,
      dob: entity.dob,
      gender: entity.gender,
      bloodGroup: entity.bloodGroup,
      category: entity.category,
      religion: entity.religion,
      aadharNumber: entity.aadharNumber,
      joiningDate: entity.joiningDate,
      currentPosting: entity.currentPosting,
      employeeType: entity.employeeType,
      payLevel: entity.payLevel,
      currentBasicPay: entity.currentBasicPay,
      maritalStatus: entity.maritalStatus,
      spouseName: entity.spouseName,
      children: entity.children,
      fatherName: entity.fatherName,
      motherName: entity.motherName,
      presentAddress: entity.presentAddress,
      permanentAddress: entity.permanentAddress,
      emergencyContact: entity.emergencyContact,
      bankName: entity.bankName,
      accountNumber: entity.accountNumber,
      accountType: entity.accountType,
      branch: entity.branch,
      ifscCode: entity.ifscCode,
    );
  }
}