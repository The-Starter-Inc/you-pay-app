import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../constants/app_constant.dart';
import '../models/post.dart';

class PostApiProvider {
  Client client = Client();

  Future<List<Post>> fetchPosts() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${AppConstant.accessToken}'
    };
    final response = await client.get(
        Uri.parse("${AppConstant.host}/api/adspost?rows=9999"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
