import 'package:car_on_sale/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _localStorageService = LocalStorageService();

  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'surname': TextEditingController(),
    'country': TextEditingController(),
    'city': TextEditingController(),
    'age': TextEditingController(),
  };

  Future<void> _saveUserData() async {
    Map<String, dynamic> userData =
        _controllers.map((key, value) => MapEntry(key, value.text));
    await _localStorageService.saveUserData(userData);
  }

  Widget _buildTextField(String label, String key) {
    return TextFormField(
      controller: _controllers[key],
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
      keyboardType: key == 'age' ? TextInputType.number : TextInputType.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextField('Name', 'name'),
              _buildTextField('Surname', 'surname'),
              _buildTextField('Country', 'country'),
              _buildTextField('City', 'city'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _saveUserData().then((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    });
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
