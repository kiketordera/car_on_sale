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
        Uri.https('www.caronsale.com'),
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
    List<VehicleOption> options = parseVehicleOptions(responseBody);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleSelectionScreen(options),
      ),
    ).then((selectedVehicleId) {
      if (selectedVehicleId != null) {
        setState(() {
          _statusMessage = 'Selected vehicle ID: $selectedVehicleId';
        });
      }
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

class VehicleOption {
  final String make;
  final String model;
  final String containerName;
  final int similarity;
  final String externalId;

  VehicleOption({
    required this.make,
    required this.model,
    required this.containerName,
    required this.similarity,
    required this.externalId,
  });

  factory VehicleOption.fromJson(Map<String, dynamic> json) {
    return VehicleOption(
      make: json['make'],
      model: json['model'],
      containerName: json['containerName'],
      similarity: json['similarity'],
      externalId: json['externalId'],
    );
  }
}

List<VehicleOption> parseVehicleOptions(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<VehicleOption>((json) => VehicleOption.fromJson(json))
      .toList();
}

class VehicleSelectionScreen extends StatelessWidget {
  final List<VehicleOption> options;

  const VehicleSelectionScreen(this.options, {super.key});

  @override
  Widget build(BuildContext context) {
    // Sort options by similarity
    options.sort((a, b) => b.similarity.compareTo(a.similarity));

    return Scaffold(
      appBar: AppBar(title: const Text("Select Vehicle")),
      body: ListView.builder(
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];
          return ListTile(
            title: Text('${option.make} ${option.model}'),
            subtitle: Text(
                'Similarity: ${option.similarity}\nContainer: ${option.containerName}'),
            onTap: () {
              Navigator.pop(context, option.externalId);
            },
          );
        },
      ),
    );
  }
}
