import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'dart:convert';

import '../models/feedback.dart';

class FeedbackApiProvider {
  Client client = Client();
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${AppConstant.accessToken}'
  };

  Future<List<Feedback>> fetchFeedbacks(String firebaseUserId) async {
    final response = await client.get(
        Uri.parse(
            "${AppConstant.host}/api/feedback?ads_user_id=$firebaseUserId&sort=id&order=desc&rows=99999"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Feedback.fromMapArray(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }

  Future<List<Feedback>> checkFeedbackExist(
      String adsUserId, String exUserId) async {
    final response = await client.get(
        Uri.parse(
            "${AppConstant.host}/api/feedback?search=ads_user_id:equal:$adsUserId|ex_user_id:equal:$exUserId"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Feedback.fromMap(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }

  Future<Feedback> createFeedback(Map<String, dynamic> payload) async {
    final response = await client.post(
        Uri.parse("${AppConstant.host}/api/feedback"),
        headers: headers,
        body: json.encode(payload));

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Feedback.fromMap(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }
}
