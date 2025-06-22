
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/account_summary.dart';
import '../widgets/account_table.dart';
import '../widgets/add_account_form.dart';
import '../providers/account_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<AccountProvider>(context, listen: false).loadAccountsFromFirestore();
    });
  }

  void _openAddAccountForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const AddAccountForm(),
    ).then((_) {
      Provider.of<AccountProvider>(context, listen: false).loadAccountsFromFirestore();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _openAddAccountForm,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 130,
            child: AccountSummary(),
          ),
          Expanded(
            child: AccountTable(),
          ),
        ],
      ),
    );
  }
}
