import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../constants/app_constant.dart';
import '../models/sponsor.dart';

class SponsorApiProvider {
  Client client = Client();
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${AppConstant.accessToken}'
  };

  Future<List<Sponsor>> fetchSponsors(type) async {
    final response = await client.get(
        Uri.parse(
            "${AppConstant.host}/api/sponsor?search=type:equal:$type&rows=9999"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Sponsor.fromMapArray(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load sponsor');
    }
  }
}
