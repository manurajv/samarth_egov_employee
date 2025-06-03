import '../../domain/entities/profile_entity.dart';

class ProfileModel {
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

  factory ProfileModel.fromJson(Map<String, dynamic> json, {
    required String fullName,
    required String designation,
    required String department,
  }) {
    return ProfileModel(
      employeeId: json['employeeId']?.toString() ?? '',
      fullName: fullName,
      designation: designation,
      department: department,
      dob: json['personal']?['dob']?.toString() ?? '',
      gender: json['personal']?['gender']?.toString() ?? '',
      bloodGroup: json['personal']?['bloodGroup']?.toString() ?? '',
      category: json['personal']?['category']?.toString() ?? '',
      religion: json['personal']?['religion']?.toString() ?? '',
      aadharNumber: json['personal']?['aadharNumber']?.toString() ?? '',
      joiningDate: json['service']?['joiningDate']?.toString() ?? '',
      currentPosting: json['service']?['currentPosting']?.toString() ?? '',
      employeeType: json['service']?['employeeType']?.toString() ?? '',
      payLevel: json['service']?['payLevel']?.toString() ?? '',
      currentBasicPay: json['service']?['currentBasicPay']?.toString() ?? '',
      maritalStatus: json['family']?['maritalStatus']?.toString() ?? '',
      spouseName: json['family']?['spouseName']?.toString() ?? '',
      children: (json['family']?['children'] as num?)?.toInt() ?? 0,
      fatherName: json['family']?['fatherName']?.toString() ?? '',
      motherName: json['family']?['motherName']?.toString() ?? '',
      presentAddress: json['address']?['presentAddress']?.toString() ?? '',
      permanentAddress: json['address']?['permanentAddress']?.toString() ?? '',
      emergencyContact: json['address']?['emergencyContact']?.toString() ?? '',
      bankName: json['bank']?['bankName']?.toString() ?? '',
      accountNumber: json['bank']?['accountNumber']?.toString() ?? '',
      accountType: json['bank']?['accountType']?.toString() ?? '',
      branch: json['bank']?['branch']?.toString() ?? '',
      ifscCode: json['bank']?['ifscCode']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
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