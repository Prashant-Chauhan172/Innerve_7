import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIDController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  bool _isLoading = false;

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
    });

    final String userID = _userIDController.text;
    final String pinCode = _pinCodeController.text;
    final String apiUrl = 'http://47.87.230.176:5000/api/login';

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: {'userID': userID, 'pinCode': pinCode},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final bool isLogged = responseBody['isLogged'];

        if (isLogged) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                userID: userID,
                userPIN: pinCode,
              ),
            ),
          );
        } else {
          _showErrorDialog('Login Failed', 'Invalid user credentials.');
        }
      } else {
        _showErrorDialog('Error', 'Failed to log in. Please try again later.');
      }
    } catch (e) {
      _showErrorDialog(
          'Error', 'Something went wrong. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _userIDController,
                      decoration: const InputDecoration(
                        labelText: 'User ID',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _pinCodeController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'PIN Code',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _loginUser,
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
