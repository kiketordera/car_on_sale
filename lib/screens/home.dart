import 'package:car_on_sale/models/vehicle_options.dart';
import 'package:car_on_sale/screens/auction_data.dart';
import 'package:car_on_sale/screens/vehicle_selection.dart';
import 'package:car_on_sale/services/api_service.dart';
import 'package:car_on_sale/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  final _localStorageService = LocalStorageService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _vinController = TextEditingController();
  String _statusMessage = '';
  Map<String, String>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await _localStorageService.getUserData();
    setState(() {
      _userData = userData;
    });
  }

  Future<void> _fetchVinData() async {
    if (_userData == null) return;

    try {
      final response = await _apiService.fetchData(_vinController.text);
      if (response.statusCode == 200) {
        _handleSuccess(response.body);
      } else if (response.statusCode == 300) {
        _handleMultipleOptions(response.body);
      } else {
        _handleError(response.reasonPhrase);
      }
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('auctionData');
      if (cachedData != null && mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AuctionDataScreen(cachedData)),
        );
      } else {
        setState(() {
          _statusMessage = 'No data in cache';
        });
      }
    }
  }

  void _handleSuccess(String responseBody) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auctionData', responseBody);

    setState(() {
      _statusMessage = 'Data fetched successfully';
    });

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AuctionDataScreen(responseBody)),
      );
    }
  }

  void _handleMultipleOptions(String responseBody) {
    List<VehicleOption> options = parseVehicleOptions(responseBody);
    if (mounted) {
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
