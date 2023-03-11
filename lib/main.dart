import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String userID = "";
  String pinCode = "";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PayMe',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(userID: userID, userPIN: pinCode),
      },
    );
  }
}
