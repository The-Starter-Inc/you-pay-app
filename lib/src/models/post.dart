// ignore_for_file: file_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Post {
  int id;
  Type type;
  List<Provider> providers;
  double amount;
  String phone;
  LatLng latLng;
  double distance;
  double? percentage;
  double? fees;
  String firebaseUserId;
  String deviceId;
  int? userId;
  String createdAt;

  Post(
      {required this.id,
      required this.type,
      required this.providers,
      required this.amount,
      required this.phone,
      required this.latLng,
      required this.distance,
      required this.firebaseUserId,
      required this.deviceId,
      this.percentage,
      this.fees,
      this.userId,
      required this.createdAt});

  static fromJsonProviders(parsedJson) {
    final List<Provider> providers = [];
    for (int i = 0; i < parsedJson.length; i++) {
      if (parsedJson[i]['provider'] != null) {
        providers.add(Provider(
            id: parsedJson[i]['provider']['id'],
            name: parsedJson[i]['provider']['name'],
            image: ImageUrl(url: parsedJson[i]['provider']['image']['url']),
            marker: ImageUrl(url: parsedJson[i]['provider']['marker']['url']),
            icon: ImageUrl(url: parsedJson[i]['provider']['icon']['url'])));
      }
    }
    return providers;
  }

  static fromJson(parsedJson) {
    List<Post> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(Post(
          id: parsedJson[i]['id'],
          type: Type(
              id: parsedJson[i]['type']['id'],
              name: parsedJson[i]['type']['name']),
          providers: Post.fromJsonProviders(parsedJson[i]['providers'] ?? []),
          amount: double.parse(parsedJson[i]['amount'].toString()).toDouble(),
          phone: parsedJson[i]['phone'],
          latLng: LatLng(parsedJson[i]['lat'], parsedJson[i]['lng']),
          distance:
              double.parse(parsedJson[i]['distance'].toString()).toDouble(),
          percentage:
              double.parse((parsedJson[i]['percentage'] ?? 0).toString())
                  .toDouble(),
          fees:
              double.parse((parsedJson[i]['fees'] ?? 0).toString()).toDouble(),
          firebaseUserId: parsedJson[i]['firebase_user_id'],
          deviceId: parsedJson[i]['device_id'],
          userId: parsedJson[i]['user_id'],
          createdAt: parsedJson[i]['type']['created_at']));
    }
    return results;
  }

  static fromJsonObj(parsedJson) {
    return Post(
        id: parsedJson['id'],
        type: Type(
            id: parsedJson['type']['id'], name: parsedJson['type']['name']),
        providers: Post.fromJsonProviders(parsedJson['providers'] ?? []),
        amount: double.parse(parsedJson['amount'].toString()).toDouble(),
        phone: parsedJson['phone'],
        latLng: LatLng(parsedJson['lat'], parsedJson['lng']),
        distance: double.parse(parsedJson['distance'].toString()).toDouble(),
        percentage:
            double.parse((parsedJson['percentage'] ?? 0).toString()).toDouble(),
        fees: double.parse((parsedJson['fees'] ?? 0).toString()).toDouble(),
        firebaseUserId: parsedJson['firebase_user_id'],
        deviceId: parsedJson['device_id'],
        userId: parsedJson['user_id'],
        createdAt: parsedJson['type']['created_at']);
  }
}

class Type {
  final int id;
  final String name;
  ImageUrl? icon;

  Type({required this.id, required this.name, this.icon});

  static fromJson(Map<String, dynamic> parsedJson) {
    List<Type> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(Type(id: parsedJson[i]['id'], name: parsedJson[i]['name']));
    }
  }
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

  static fromJson(List<dynamic> parsedJson) {
    List<Provider> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(Provider(
        id: parsedJson[i]['id'],
        name: parsedJson[i]['name'],
        image: ImageUrl(url: parsedJson[i]['image']['url']),
        marker: ImageUrl(url: parsedJson[i]['marker']['url']),
        icon: ImageUrl(url: parsedJson[i]['icon']['url']),
      ));
    }
    return results;
  }
}

class ImageUrl {
  String url;
  ImageUrl({required this.url});
}
