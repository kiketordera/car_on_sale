import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      return Map<String, dynamic>.from(jsonDecode(userDataString));
    }
    return null;
  }

  Future<void> saveCacheData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cache', jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getCacheData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('cache');
    if (userDataString != null) {
      return Map<String, dynamic>.from(jsonDecode(userDataString));
    }
    return null;
  }
}
