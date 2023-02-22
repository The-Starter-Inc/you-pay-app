import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'dart:convert';
import '../models/post.dart';

class AdsApiProvider {
  Client client = Client();

  Future<List<Provider>> fetchProviders() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AppConstant.accessToken}'
    };
    final response = await client.get(
        Uri.parse("${AppConstant.host}/api/provider?rows=99"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Provider.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load providers');
    }
  }
}
