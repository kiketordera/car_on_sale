import 'package:car_on_sale/snippet.dart';
import 'package:http/http.dart' as http;

class ApiService {

  Future<http.Response> fetchData(String vin) async {
    final response = await CosChallenge.httpClient
        .get(Uri.https('anyUrl'), headers: {CosChallenge.user: 'someUserId'});
    return response;
  }
}
