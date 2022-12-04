import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groupchat_app/helper/helper_function.dart';
import 'package:groupchat_app/pages/auth/register_page.dart';
import 'package:groupchat_app/pages/home_page.dart';
import 'package:groupchat_app/pages/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await helper_function.getUserLoggedInInstance().then((value) {
      if (value == true) {
        setState(() {
          _isSignedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (context) => RegisterPage(),
      },
      home: _isSignedIn ? HomePage() : LoginPage(),
    );
  }
}
