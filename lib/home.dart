import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'snippet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vinController = TextEditingController();
  String _statusMessage = '';
  Map<String, String>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      setState(() {
        userData = Map<String, String>.from(
            jsonDecode(userDataString)); // Use jsonDecode
      });
    }
  }

  Future<void> _fetchVinData() async {
    if (userData == null) return;

    try {
      final response = await CosChallenge.httpClient.get(
        Uri.https('anyUrl', ''),
        headers: {CosChallenge.user: userData!['name'] ?? 'unknownUser'},
      );

      if (response.statusCode == 200) {
        _handleSuccess(response.body);
      } else if (response.statusCode == 300) {
        _handleMultipleOptions(response.body);
      } else {
        _handleError(response.reasonPhrase);
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'An error occurred: $e';
      });
    }
  }

  void _handleSuccess(String responseBody) {
    setState(() {
      _statusMessage = 'Data fetched successfully';
    });
  }

  void _handleMultipleOptions(String responseBody) {
    setState(() {
      _statusMessage = 'Multiple options available. Please refine your search.';
    });
  }

  void _handleError(String? reasonPhrase) {
    setState(() {
      _statusMessage = 'Error: $reasonPhrase';
    });
  }

  Widget _buildVinForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _vinController,
            decoration: const InputDecoration(labelText: 'VIN'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the VIN';
              }
              final vinPattern = RegExp(r'^[A-HJ-NPR-Z0-9]{17}$');
              if (!vinPattern.hasMatch(value)) {
                return 'Please enter a valid 17-character VIN';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _fetchVinData();
              }
            },
            child: const Text('Submit'),
          ),
          const SizedBox(height: 20),
          Text(_statusMessage),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildVinForm(),
      ),
    );
  }
}
