import 'package:car_on_sale/home.dart';
import 'package:car_on_sale/signup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('VIN Validator')),
        body: FutureBuilder(
          future: _checkUserSignedUp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.data == true) {
              return const HomeScreen();
            } else {
              return const SignUpScreen();
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkUserSignedUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('userData');
  }
}
