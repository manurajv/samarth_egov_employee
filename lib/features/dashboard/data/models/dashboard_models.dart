import 'package:equatable/equatable.dart';

class LeaveBalance extends Equatable {
  final String leaveType;
  final int total;
  final int availed;
  final int balance;
  final String id;

  const LeaveBalance({
    required this.leaveType,
    required this.total,
    required this.availed,
    required this.balance,
    required this.id,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) => LeaveBalance(
    leaveType: json['leaveType'] as String,
    total: (json['total'] as num?)?.toInt() ?? (json['availableDays'] as num).toInt(),
    availed: (json['availed'] as num?)?.toInt() ?? 0,
    balance: (json['balance'] as num?)?.toInt() ?? (json['availableDays'] as num).toInt(),
    id: json['id'] as String,
  );

  @override
  List<Object> get props => [leaveType, total, availed, balance, id];
}

class ServiceRecord extends Equatable {
  final String id;
  final String eventType;
  final String effectiveDate;
  final String details;

  const ServiceRecord({
    required this.id,
    required this.eventType,
    required this.effectiveDate,
    required this.details,
  });

  factory ServiceRecord.fromJson(Map<String, dynamic> json) => ServiceRecord(
    id: json['id'] as String? ?? '',
    eventType: json['eventType'] as String? ?? '',
    effectiveDate: json['effectiveDate'] as String? ?? '',
    details: json['details'] as String? ?? '',
  );

  @override
  List<Object> get props => [id, eventType, effectiveDate, details];
}

class Appraisal extends Equatable {
  final String id;
  final String year;
  final String status;

  const Appraisal({
    required this.id,
    required this.year,
    required this.status,
  });

  factory Appraisal.fromJson(Map<String, dynamic> json) => Appraisal(
    id: json['id'] as String? ?? '',
    year: json['year'] as String? ?? '',
    status: json['status'] as String? ?? '',
  );

  @override
  List<Object> get props => [id, year, status];
}

class Grievance extends Equatable {
  final String id;
  final String subject;
  final String status;
  final String dateFiled;

  const Grievance({
    required this.id,
    required this.subject,
    required this.status,
    required this.dateFiled,
  });

  factory Grievance.fromJson(Map<String, dynamic> json) => Grievance(
    id: json['id'] as String? ?? '',
    subject: json['subject'] as String? ?? '',
    status: json['status'] as String? ?? '',
    dateFiled: json['dateFiled'] as String? ?? '',
  );

  @override
  List<Object> get props => [id, subject, status, dateFiled];
}

class SalarySlip extends Equatable {
  final String id;
  final String monthYear;
  final double amount;

  const SalarySlip({
    required this.id,
    required this.monthYear,
    required this.amount,
  });

  factory SalarySlip.fromJson(Map<String, dynamic> json) => SalarySlip(
    id: json['id'] as String? ?? '',
    monthYear: json['monthYear'] as String? ?? '',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
  );

  @override
  List<Object> get props => [id, monthYear, amount];
}