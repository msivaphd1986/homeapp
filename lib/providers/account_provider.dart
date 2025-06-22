
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/account.dart';

class AccountProvider with ChangeNotifier {
  List<Account> _accounts = [];

  List<Account> get accounts => _accounts;

  void addOrUpdateAccount(Account account) {
    final index = _accounts.indexWhere((a) => a.id == account.id);
    if (index >= 0) {
      _accounts[index] = account;
    } else {
      _accounts.add(account);
    }
    notifyListeners();
  }

  Future<void> loadAccountsFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance.collection('accounts').get();
    _accounts = snapshot.docs.map((doc) {
      final data = doc.data();
      return Account(
        id: data['id'],
        accountType: data['accountType'],
        provider: data['provider'],
        currency: data['currency'],
        accountName: data['accountName'],
        accountNumber: data['accountNumber'],
        creditLimit: (data['creditLimit'] ?? 0).toDouble(),
        initialBalance: (data['initialBalance'] ?? 0).toDouble(),
        openedDate: DateTime.parse(data['openedDate']),
        closingDay: data['closingDay'],
        dueDay: data['dueDay'],
        aprEndDate: DateTime.parse(data['aprEndDate']),
        notes: data['notes'],
      );
    }).toList();
    notifyListeners();
  }

  Future<void> deleteAccount(String id) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('accounts')
          .where('id', isEqualTo: id)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }

      _accounts.removeWhere((acc) => acc.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting account: \$e');
    }
  }
}
