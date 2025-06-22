
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final accounts = context.watch<AccountProvider>().accounts;

    double usdIncome = 0;
    double inrIncome = 0;
    double usdExpense = 0;
    double inrExpense = 0;
    double usdSavings = 0;
    double inrSavings = 0;
    double usdCurrBal = 0;
    double inrCurrBal = 0;
    int usdCount = 0;
    int inrCount = 0;

    for (var acc in accounts) {
      double savings = acc.initialBalance;
      double currentBal = acc.initialBalance;

      if (acc.currency == 'USD') {
        usdSavings += savings;
        usdCurrBal += currentBal;
        usdCount++;
      } else if (acc.currency == 'INR') {
        inrSavings += savings;
        inrCurrBal += currentBal;
        inrCount++;
      }
    }

    return SizedBox(
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _summaryCard('Income', usdIncome, inrIncome),
          _summaryCard('Expense', usdExpense, inrExpense),
          _summaryCard('Savings', usdSavings, inrSavings),
          _summaryCard('Curr Bal', usdCurrBal, inrCurrBal),
          _countCard('Acct by Curr', usdCount, inrCount),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, double usdValue, double inrValue) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Container(
        width: 160,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('USD: \$${usdValue.toStringAsFixed(2)}'),
            Text('INR: ₹${inrValue.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  Widget _countCard(String label, int usd, int inr) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Container(
        width: 180,
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('USD Accts: $usd'),
            Text('INR Accts: $inr'),
          ],
        ),
      ),
    );
  }
}
