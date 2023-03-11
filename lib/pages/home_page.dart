import 'package:flutter/material.dart';
import 'send_money_page.dart';
import 'receive_money_page.dart';

class HomePage extends StatelessWidget {
  final String userID;
  final String userPIN;

  HomePage({required this.userID, required this.userPIN});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SendMoneyPage(userID: userID, userPIN: userPIN),
                  ),
                );
              },
              child: Text('Send Money'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReceiveMoneyPage(userID: userID),
                  ),
                );
              },
              child: Text('Receive Money'),
            ),
          ],
        ),
      ),
    );
  }
}
