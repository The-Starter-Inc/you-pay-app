// ignore_for_file: file_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Post {
  int id;
  Type type;
  Provider provider;
  double amount;
  String phone;
  LatLng latLng;
  double distance;
  double? percentage;
  double? fixedAmount;

  static final List<Post> _results = [];

  Post(
      {required this.id,
      required this.type,
      required this.provider,
      required this.amount,
      required this.phone,
      required this.latLng,
      required this.distance,
      this.percentage,
      this.fixedAmount});

  static fromJson(Map<String, dynamic> parsedJson) {
    for (int i = 0; i < parsedJson.length; i++) {
      _results.add(Post(
        id: parsedJson[i]['id'],
        type: parsedJson[i]['type'],
        provider: parsedJson[i]['provider'],
        amount: parsedJson[i]['amount'],
        phone: parsedJson[i]['phone'],
        latLng: LatLng(parsedJson[i]['lat'], parsedJson[i]['lng']),
        distance: parsedJson[i]['distance'],
        percentage: parsedJson[i]['percentage'],
        fixedAmount: parsedJson[i]['fixedAmount'],
      ));
    }
  }

  List<Post> get results => _results;
}

class Type {
  final int id;
  final String name;
  ImageUrl? icon;

  Type({required this.id, required this.name, this.icon});
}

class Provider {
  int id;
  String name;
  ImageUrl image;
  ImageUrl marker;
  ImageUrl icon;

  Provider(
      {required this.id,
      required this.name,
      required this.image,
      required this.marker,
      required this.icon});
}

class ImageUrl {
  String url;
  ImageUrl({required this.url});
}
