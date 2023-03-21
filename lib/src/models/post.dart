// ignore_for_file: file_names

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'user.dart';

class Post {
  int id;
  Type? type;
  List<Provider> providers;
  double amount;
  String phone;
  LatLng latLng;
  double distance;
  String chargesType;
  double? percentage;
  double? fees;
  int? priority;
  String adsUserId;
  String adsDeviceId;
  User? adsUser;
  String createdAt;

  Post(
      {required this.id,
      this.type,
      required this.providers,
      required this.amount,
      required this.phone,
      required this.latLng,
      required this.distance,
      required this.adsUserId,
      required this.adsDeviceId,
      required this.chargesType,
      this.adsUser,
      this.percentage,
      this.fees,
      this.priority,
      required this.createdAt});

  static fromJsonProviders(parsedJson) {
    final List<Provider> providers = [];
    for (int i = 0; i < parsedJson.length; i++) {
      providers.add(Provider(
          id: parsedJson[i]['id'],
          name: parsedJson[i]['name'],
          image: ImageUrl(url: parsedJson[i]['image']['url']),
          marker: ImageUrl(url: parsedJson[i]['marker']['url']),
          icon: ImageUrl(url: parsedJson[i]['icon']['url']),
          color: parsedJson[i]['color']));
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
          chargesType: parsedJson[i]['charges_type'] ?? "percentage",
          percentage:
              double.parse((parsedJson[i]['percentage'] ?? 0).toString())
                  .toDouble(),
          priority:
              double.parse((parsedJson[i]['priority'] ?? 0).toString()).toInt(),
          fees:
              double.parse((parsedJson[i]['fees'] ?? 0).toString()).toDouble(),
          adsUserId: parsedJson[i]['ads_user_id'],
          adsDeviceId: parsedJson[i]['ads_device_id'],
          adsUser: parsedJson[i]['ads_user'] != null
              ? User.fromMap(parsedJson[i]['ads_user'])
              : null,
          createdAt: parsedJson[i]['created_at']));
    }
    return results;
  }

  static fromJsonObj(parsedJson) {
    return Post(
        id: parsedJson['id'],
        type: parsedJson['type'] != null
            ? Type(
                id: parsedJson['type']['id'], name: parsedJson['type']['name'])
            : null,
        providers: Post.fromJsonProviders(parsedJson['providers'] ?? []),
        amount: double.parse(parsedJson['amount'].toString()).toDouble(),
        phone: parsedJson['phone'],
        latLng: LatLng(parsedJson['lat'], parsedJson['lng']),
        distance: double.parse(parsedJson['distance'].toString()).toDouble(),
        chargesType: parsedJson['charges_type'] ?? 'percentage',
        percentage:
            double.parse((parsedJson['percentage'] ?? 0).toString()).toDouble(),
        fees: double.parse((parsedJson['fees'] ?? 0).toString()).toDouble(),
        adsUserId: parsedJson['ads_user_id'],
        adsDeviceId: parsedJson['ads_device_id'],
        adsUser: parsedJson['ads_user'] != null
            ? User.fromMap(parsedJson['ads_user'])
            : null,
        createdAt: parsedJson['created_at']);
  }
}

class Type {
  final int id;
  final String name;
  ImageUrl? icon;

  Type({required this.id, required this.name, this.icon});

  static fromJson(parsedJson) {
    List<Type> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(Type(id: parsedJson[i]['id'], name: parsedJson[i]['name']));
    }
    return results;
  }
}

class Provider {
  int id;
  String name;
  ImageUrl image;
  ImageUrl marker;
  ImageUrl icon;
  String? color;

  Provider(
      {required this.id,
      required this.name,
      required this.image,
      required this.marker,
      required this.icon,
      this.color});

  static fromJson(List<dynamic> parsedJson) {
    List<Provider> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(Provider(
        id: parsedJson[i]['id'],
        name: parsedJson[i]['name'],
        image: ImageUrl(url: parsedJson[i]['image']['url']),
        marker: ImageUrl(url: parsedJson[i]['marker']['url']),
        icon: ImageUrl(url: parsedJson[i]['icon']['url']),
        color: parsedJson[i]['color'],
      ));
    }
    return results;
  }

  static List<dynamic> toJsonArray(List<Provider> providers) {
    final List<dynamic> result = [];
    for (var i = 0; i < providers.length; i++) {
      result.add({
        'id': providers[i].id,
        'name': providers[i].name,
        'image': ImageUrl.toJson(providers[i].image),
        'icon': ImageUrl.toJson(providers[i].icon),
        'marker': ImageUrl.toJson(providers[i].marker),
        'color': providers[i].color
      });
    }
    return result;
  }
}

class ImageUrl {
  String url;
  ImageUrl({required this.url});

  static dynamic toJson(ImageUrl imageUrl) {
    return {'url': imageUrl.url};
  }
}
