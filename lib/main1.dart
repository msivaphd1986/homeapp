import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'screens/account_screen.dart';
import 'providers/account_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountProvider()..loadAccounts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Home Finance',
        theme: ThemeData.dark(),
        home: AccountScreen(),
      ),
    );
  }
}