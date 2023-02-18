// ignore_for_file: file_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Post {
  String icon;
  String phone;
  LatLng latLng;
  static final List<Post> _results = [];

  Post({required this.icon, required this.phone, required this.latLng});

  static fromJson(Map<String, dynamic> parsedJson) {
    for (int i = 0; i < parsedJson.length; i++) {
      _results.add(Post(
          icon: parsedJson[i]['icon'],
          phone: parsedJson[i]['phone'],
          latLng: LatLng(parsedJson[i]['lat'], parsedJson[i]['lng'])));
    }
  }

  List<Post> get results => _results;
}
