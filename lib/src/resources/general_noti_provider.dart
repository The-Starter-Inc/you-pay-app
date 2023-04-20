import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../constants/app_constant.dart';
import '../models/general_noti.dart';

class GeneralNotiApiProvider {
  Client client = Client();
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${AppConstant.accessToken}'
  };

  Future<List<GeneralNoti>> fetchSGeneralNotifications() async {
    final response = await client.get(
        Uri.parse(
            "${AppConstant.host}/api/pushnotification?search=status:equal:Success&rows=99&sort=id&order=desc"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return GeneralNoti.fromMapArray(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load GeneralNoti');
    }
  }
}
