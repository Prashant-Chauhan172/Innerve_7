import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';

class SendMoneyPage extends StatefulWidget {
  final String userID;
  final String userPIN;

  SendMoneyPage({required this.userID, required this.userPIN});

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  TextEditingController amountController = TextEditingController();
  late String _randomString;

  void _payNow() async {
    if (amountController.text.isNotEmpty) {
      // Generate random string
      final _chars =
          'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
      final _rnd = Random();
      _randomString = String.fromCharCodes(Iterable.generate(
          10, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
      print("Random String: $_randomString");

      // Send POST request to http://47.87.230.176:5000/api/send/
      var response = await http.post(
        Uri.parse('http://47.87.230.176:5000/api/send/'),
        headers: <String, String>{'Content-Type': 'application/json'},
        body: jsonEncode(<String, String>{
          'userId': widget.userID,
          'randomString': _randomString,
          'userPin': widget.userPIN,
        }),
      );
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['isSubmitted'] == true) {
          // Write to NFC card
          Uri uri = Uri.parse(
              'http://47.87.230.176:5000/api/recieve/?userid=${widget.userID}&token=$_randomString');
          NDEFMessage message = NDEFMessage.withRecords([NDEFRecord.uri(uri)]);

          Stream<NDEFTag> stream = NFC.writeNDEF(message);

          stream.listen((NDEFTag tag) {
            print("Wrote to tag successfully");
            Navigator.pop(context);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Money"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Enter amount",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _payNow,
              child: Text("Pay Now"),
            ),
          ],
        ),
      ),
    );
  }
}
