import 'dart:async';
import 'package:http/http.dart' show Client;
import './../constants/app_constant.dart';

import 'dart:convert';
import '../models/token.dart';

class AuthApiProvider {
  Client client = Client();

  Future<Token> fetchToken(payload) async {
    final response = await client
        .post(Uri.parse("${AppConstant.host}/oauth/token"), body: payload);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Token.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
