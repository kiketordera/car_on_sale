import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _vinController = TextEditingController();
  bool _isButtonEnabled = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _vinController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _vinController.dispose();
    super.dispose();
  }

  void _validateInput() {
    final vin = _vinController.text;
    setState(() {
      _isButtonEnabled = _isValidVIN(vin);
      _errorMessage = _isButtonEnabled ? null : 'Invalid VIN';
    });
  }

  bool _isValidVIN(String vin) {
    final regex = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$');
    return regex.hasMatch(vin);
  }

  void _submitVIN() async {
   
  }



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _vinController,
              decoration: InputDecoration(
                labelText: 'Enter VIN',
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isButtonEnabled ? _submitVIN : null,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
