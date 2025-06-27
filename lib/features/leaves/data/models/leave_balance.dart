class LeaveBalance {
  final String id;
  final String leaveType;
  final int? total;
  final int? availed;
  final int? balance;

  LeaveBalance({
    required this.id,
    required this.leaveType,
    this.total,
    this.availed,
    this.balance,
  });

  factory LeaveBalance.fromJson(Map<String, dynamic> json) {
    print('Parsing LeaveBalance: $json'); // Debug JSON input
    return LeaveBalance(
      id: json['id'] as String? ?? '',
      leaveType: json['leaveType'] as String? ?? 'Unknown',
      total: json['total'] as int?, // Handle null
      availed: json['availed'] as int?, // Handle null
      balance: json['balance'] as int?, // Handle null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leaveType': leaveType,
      'total': total,
      'availed': availed,
      'balance': balance,
    };
  }
}