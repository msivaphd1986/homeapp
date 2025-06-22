
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/account.dart';

class FirestoreService {
  final CollectionReference _accountCollection =
      FirebaseFirestore.instance.collection('accounts');

  Future<void> addOrUpdateAccount(Account account) async {
    await _accountCollection.doc(account.id).set(account.toMap());
  }

  Future<void> deleteAccount(String id) async {
    await _accountCollection.doc(id).delete();
  }

  Stream<List<Account>> getAccounts() {
    return _accountCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Account.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
