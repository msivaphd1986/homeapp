
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/account.dart';
import '../providers/account_provider.dart';
import 'add_account_form.dart';

class AccountTable extends StatelessWidget {
  final List<String> headers = [
    'Account Name', 'Account Number', 'Currency', 'Income', 'Expense', 'Savings',
    'Curr Bal', 'Closing Date', 'Due Date', 'Credit Limit', '0% APR End Date'
  ];

  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AccountProvider>().accounts;

    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: headers.length * 150,
          child: Column(
            children: [
              // Header row
              Container(
                color: Colors.grey.shade900,
                child: Row(
                  children: headers.map((header) {
                    return Container(
                      width: 150,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        header,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Data rows
              Expanded(
                child: ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final acc = accounts[index];

                    final values = [
                      acc.accountName,
                      acc.accountNumber,
                      acc.currency,
                      '0.00',
                      '0.00',
                      acc.initialBalance.toStringAsFixed(2),
                      acc.initialBalance.toStringAsFixed(2),
                      acc.closingDay.toString(),
                      acc.dueDay.toString(),
                      acc.creditLimit.toStringAsFixed(2),
                      acc.aprEndDate.toLocal().toString().split(' ')[0],
                    ];

                    return Dismissible(
                      key: Key(acc.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        return await showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('Delete Account?'),
                            content: Text('Are you sure you want to delete "${acc.accountName}"?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel')),
                              TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete')),
                            ],
                          ),
                        );
                      },
                      onDismissed: (_) {
                        context.read<AccountProvider>().deleteAccount(acc.id);
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) => AddAccountForm(existingAccount: acc),
                          );
                        },
                        child: Row(
                          children: values.map((val) {
                            return Container(
                              width: 150,
                              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
                              ),
                              child: Text(val, overflow: TextOverflow.ellipsis),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
