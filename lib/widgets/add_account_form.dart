import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';
import '../config/field_values.dart';
import 'package:uuid/uuid.dart';

class AddAccountForm extends StatefulWidget {
  final Account? existingAccount;

  const AddAccountForm({Key? key, this.existingAccount}) : super(key: key);

  @override
  _AddAccountFormState createState() => _AddAccountFormState();
}

class _AddAccountFormState extends State<AddAccountForm> {
  final _formKey = GlobalKey<FormState>();
  final _uuid = Uuid();

  late String _accountType;
  late String _currency;
  final _providerController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _creditLimitController = TextEditingController();
  final _initialBalanceController = TextEditingController();
  DateTime _openedDate = DateTime.now();
  int _closingDay = 1;
  int _dueDay = 1;
  DateTime _aprEndDate = DateTime.now();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingAccount != null) {
      final acc = widget.existingAccount!;
      _accountType = acc.accountType;
      _currency = acc.currency;
      _providerController.text = acc.provider;
      _accountNameController.text = acc.accountName;
      _accountNumberController.text = acc.accountNumber;
      _creditLimitController.text = acc.creditLimit.toString();
      _initialBalanceController.text = acc.initialBalance.toString();
      _openedDate = acc.openedDate;
      _closingDay = acc.closingDay;
      _dueDay = acc.dueDay;
      _aprEndDate = acc.aprEndDate;
      _notesController.text = acc.notes;
    } else {
      _accountType = accountFieldValues['accountTypes']![0];
      _currency = accountFieldValues['currencies']![0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingAccount != null;

    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _accountType,
                decoration: InputDecoration(labelText: 'Account Type'),
                items: accountFieldValues['accountTypes']!
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _accountType = val!),
              ),
              TextFormField(controller: _providerController, decoration: InputDecoration(labelText: 'Provider / Bank')),
              DropdownButtonFormField<String>(
                value: _currency,
                decoration: InputDecoration(labelText: 'Currency'),
                items: accountFieldValues['currencies']!
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => _currency = val!),
              ),
              TextFormField(controller: _accountNameController, decoration: InputDecoration(labelText: 'Account Name')),
              TextFormField(controller: _accountNumberController, decoration: InputDecoration(labelText: 'Account Number')),
              TextFormField(controller: _creditLimitController, decoration: InputDecoration(labelText: 'Credit Limit')),
              TextFormField(controller: _initialBalanceController, decoration: InputDecoration(labelText: 'Initial Balance')),
              ListTile(
                title: Text("Opened Date: ${_openedDate.toLocal().toString().split(' ')[0]}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _openedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _openedDate = date);
                },
              ),
              DropdownButtonFormField<int>(
                value: _closingDay,
                decoration: InputDecoration(labelText: 'Closing Day'),
                items: List.generate(31, (i) => i + 1)
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                    .toList(),
                onChanged: (val) => setState(() => _closingDay = val!),
              ),
              DropdownButtonFormField<int>(
                value: _dueDay,
                decoration: InputDecoration(labelText: 'Due Day'),
                items: List.generate(31, (i) => i + 1)
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.toString())))
                    .toList(),
                onChanged: (val) => setState(() => _dueDay = val!),
              ),
              ListTile(
                title: Text("0% APR End Date: ${_aprEndDate.toLocal().toString().split(' ')[0]}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: _aprEndDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => _aprEndDate = date);
                },
              ),
              TextFormField(controller: _notesController, decoration: InputDecoration(labelText: 'Notes')),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
                  ElevatedButton(
                    child: Text(isEditing ? 'Update' : 'Save'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final acc = Account(
                          id: isEditing ? widget.existingAccount!.id : _uuid.v4(),
                          accountType: _accountType,
                          provider: _providerController.text,
                          currency: _currency,
                          accountName: _accountNameController.text,
                          accountNumber: _accountNumberController.text,
                          creditLimit: double.tryParse(_creditLimitController.text) ?? 0,
                          initialBalance: double.tryParse(_initialBalanceController.text) ?? 0,
                          openedDate: _openedDate,
                          closingDay: _closingDay,
                          dueDay: _dueDay,
                          aprEndDate: _aprEndDate,
                          notes: _notesController.text,
                        );
                        try {
                          await FirebaseFirestore.instance.collection('accounts').add({
                            'id': acc.id,
                            'accountType': acc.accountType,
                            'provider': acc.provider,
                            'currency': acc.currency,
                            'accountName': acc.accountName,
                            'accountNumber': acc.accountNumber,
                            'creditLimit': acc.creditLimit,
                            'initialBalance': acc.initialBalance,
                            'openedDate': acc.openedDate.toIso8601String(),
                            'closingDay': acc.closingDay,
                            'dueDay': acc.dueDay,
                            'aprEndDate': acc.aprEndDate.toIso8601String(),
                            'notes': acc.notes,
                          });
                          context.read<AccountProvider>().addOrUpdateAccount(acc);
                          Navigator.pop(context);
                        } catch (e) {
                          print('Error saving to Firestore: \$e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Failed to save account')),
                          );
                        }
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
