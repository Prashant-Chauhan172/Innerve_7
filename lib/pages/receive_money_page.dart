import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'dart:convert';

class ReceiveMoneyPage extends StatefulWidget {
  final String userID;

  ReceiveMoneyPage({required this.userID});

  @override
  _ReceiveMoneyPageState createState() => _ReceiveMoneyPageState();
}

class _ReceiveMoneyPageState extends State<ReceiveMoneyPage> {
  String _amount = '';
  String _nfcData = '';

  Future<void> _processNfcData() async {
    if (_nfcData.startsWith('http://47.87.230.176:5000/api/recieve/?userid=')) {
      String url = _nfcData + '&receiverid=${widget.userID}';
      http.Response response = await http.get(Uri.parse(url));
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (responseData['isSubmitted'] == true) {
        setState(() {
          _amount = responseData['Amount'].toString();
        });
        _showTransactionSuccessDialog();
      }
    }
  }

  Future<void> _showTransactionSuccessDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction Successful'),
          content: Text('Amount Received: \$$_amount'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    NFC.readNDEF().listen((NDEFMessage message) {
      setState(() {
        _nfcData = message.records.first.payload;
      });
      _processNfcData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receive Money'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Scan NFC Card to Receive Money',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            if (_amount != '')
              Text(
                'Amount Received: \$$_amount',
                style: TextStyle(fontSize: 20.0),
              ),
          ],
        ),
      ),
    );
  }
}
