import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'dart:convert';

import '../models/exchange.dart';

class ExchangeApiProvider {
  Client client = Client();
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${AppConstant.accessToken}'
  };

  Future<List<Exchange>> fetchExchanges(String firebaseUserId) async {
    final response = await client.get(
        Uri.parse(
            "${AppConstant.host}/api/exchange?filter_user_id=$firebaseUserId&sort=id&order=desc&rows=99999"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Exchange.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }

  Future<List<Exchange>> checkExchangeExist(
      String adsPostid, String exUserId) async {
    final response = await client.get(
        Uri.parse(
            "${AppConstant.host}/api/exchange?search=ads_post_id:equal:$adsPostid|ex_user_id:equal:$exUserId|status:not_equal:completed"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Exchange.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }

  Future<Exchange> createExhange(payload) async {
    final response = await client.post(
        Uri.parse("${AppConstant.host}/api/exchange"),
        headers: headers,
        body: payload);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Exchange.fromJsonObj(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }
}
