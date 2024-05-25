import 'package:car_on_sale/services/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LocalStorageService Tests', () {
    late LocalStorageService storageService;

    setUp(() {
      storageService = LocalStorageService();
    });

    test('should save and retrieve user data', () async {
      Map<String, dynamic> userData = {'id': '123', 'name': 'Test User'};
      await storageService.saveUserData(userData);

      final retrievedData = await storageService.getUserData();
      expect(retrievedData, isNotNull);
      expect(retrievedData!['id'], '123');
      expect(retrievedData['name'], 'Test User');
    });

    test('should return null if no user data is saved', () async {
      final retrievedData = await storageService.getUserData();
      expect(retrievedData, isNull);
    });

    test('should save and retrieve cache data', () async {
      Map<String, dynamic> cacheData = {'key': 'value'};
      await storageService.saveCacheData(cacheData);

      final retrievedCacheData = await storageService.getCacheData();
      expect(retrievedCacheData, isNotNull);
      expect(retrievedCacheData!['key'], 'value');
    });

    test('should return null if no cache data is saved', () async {
      final retrievedCacheData = await storageService.getCacheData();
      expect(retrievedCacheData, isNull);
    });
  });
}
