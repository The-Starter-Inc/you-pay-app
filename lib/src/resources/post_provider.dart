import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import '../constants/app_constant.dart';
import '../models/post.dart';

class PostApiProvider {
  Client client = Client();
  Map<String, String> headers = {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${AppConstant.accessToken}'
  };

  Future<List<Post>> fetchPosts(String? keywords, String? search) async {
    // If kewords and search filter with
    if (keywords != null && search != null) {
      final response = await client.get(
          Uri.parse(
              "${AppConstant.host}/api/adspost?keyword=$keywords&search=$search&sort=percentage&order=asc&rows=9999"),
          headers: headers);
      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post');
      }
    }

    // If keywords or search filter with
    if (keywords != null || search != null) {
      // If keywords filter with
      if (keywords != null) {
        final response = await client.get(
            Uri.parse(
                "${AppConstant.host}/api/adspost?keyword=\"$keywords\"&sort=percentage&order=asc&rows=9999"),
            headers: headers);
        if (response.statusCode == 200) {
          return Post.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to load post');
        }
      } else {
        // If search filter with
        final response = await client.get(
            Uri.parse(
                "${AppConstant.host}/api/adspost?search=$search&sort=percentage&order=asc&rows=9999"),
            headers: headers);

        if (response.statusCode == 200) {
          return Post.fromJson(json.decode(response.body));
        } else {
          throw Exception('Failed to load post');
        }
      }
    } else {
      // No Filter
      final response = await client.get(
          Uri.parse(
              "${AppConstant.host}/api/adspost?sort=percentage&order=asc&rows=9999"),
          headers: headers);
      if (response.statusCode == 200) {
        return Post.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load post');
      }
    }
  }

  Future<Post> createAdsPost(payload) async {
    final response = await client.post(
        Uri.parse("${AppConstant.host}/api/adspost"),
        headers: headers,
        body: payload);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Post.fromJsonObj(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }

  Future<dynamic> deleteAdsPost(id) async {
    final response = await client.delete(
        Uri.parse("${AppConstant.host}/api/adspost/$id"),
        headers: headers);

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return response.body;
    } else {
      // If that call was not successful, throw an error.
      throw Exception(response.body);
    }
  }
}
