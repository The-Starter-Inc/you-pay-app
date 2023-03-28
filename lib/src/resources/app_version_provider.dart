import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'dart:convert';

import '../models/app_version.dart';

class AppVersionApiProvider {
  Client client = Client();
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${AppConstant.accessToken}'
  };

  Future<List<AppVersion>> fetchAppVersion() async {
    final response = await client
        .get(Uri.parse("${AppConstant.host}/api/appversion"), headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return AppVersion.fromMapArray(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }
}
