import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'dart:convert';

import '../models/verified_user.dart';

class VerifiedUserApiProvider {
  Client client = Client();
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${AppConstant.accessToken}'
  };

  Future<List<VerifiedUser>> fetchVerifiedUser(String phone) async {
    final response = await client.get(
        Uri.parse(
            "${AppConstant.host}/api/priorityuser?search=phone:equal:$phone&sort=id&order=desc"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return VerifiedUser.fromMapArray(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }
}
