import 'package:car_on_sale/screens/home.dart';
import 'package:car_on_sale/screens/signup.dart';
import 'package:car_on_sale/services/local_storage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('COS Challenge')),
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
    LocalStorageService localStorageService = LocalStorageService();
    Map<String, dynamic>? userId = await localStorageService.getUserData();
    return userId != null;
  }
}
