
class Account {
  String id;
  String accountType;
  String provider;
  String currency;
  String accountName;
  String accountNumber;
  double creditLimit;
  double initialBalance;
  DateTime openedDate;
  int closingDay;
  int dueDay;
  DateTime aprEndDate;
  String notes;

  Account({
    required this.id,
    required this.accountType,
    required this.provider,
    required this.currency,
    required this.accountName,
    required this.accountNumber,
    required this.creditLimit,
    required this.initialBalance,
    required this.openedDate,
    required this.closingDay,
    required this.dueDay,
    required this.aprEndDate,
    required this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accountType': accountType,
      'provider': provider,
      'currency': currency,
      'accountName': accountName,
      'accountNumber': accountNumber,
      'creditLimit': creditLimit,
      'initialBalance': initialBalance,
      'openedDate': openedDate.toIso8601String(),
      'closingDay': closingDay,
      'dueDay': dueDay,
      'aprEndDate': aprEndDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'],
      accountType: map['accountType'],
      provider: map['provider'],
      currency: map['currency'],
      accountName: map['accountName'],
      accountNumber: map['accountNumber'],
      creditLimit: map['creditLimit'],
      initialBalance: map['initialBalance'],
      openedDate: DateTime.parse(map['openedDate']),
      closingDay: map['closingDay'],
      dueDay: map['dueDay'],
      aprEndDate: DateTime.parse(map['aprEndDate']),
      notes: map['notes'],
    );
  }
}
