// ignore_for_file: file_names

import 'dart:convert';

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
  double? exchangeRate;
  int? priority;
  String adsUserId;
  String adsDeviceId;
  User? adsUser;
  bool? status;
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
      this.exchangeRate,
      this.priority,
      this.status,
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

  static fromMapArray(parsedJson) {
    List<Post> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(fromMap(parsedJson[i]));
    }
    return results;
  }

  static fromMap(parsedJson) {
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
        exchangeRate:
            double.parse((parsedJson['exchange_rate'] ?? 0).toString())
                .toDouble(),
        adsUserId: parsedJson['ads_user_id'],
        adsDeviceId: parsedJson['ads_device_id'],
        adsUser: parsedJson['ads_user'] != null
            ? User.fromMap(parsedJson['ads_user'])
            : null,
        priority: parsedJson['priority'] ?? 0,
        status: parsedJson['status'],
        createdAt: parsedJson['created_at']);
  }

  toJson() {
    return {
      "id": "$id",
      "type_id": "${type!.id}",
      "amount": "$amount",
      "charges_type": chargesType,
      "percentage": "$percentage",
      "fees": "$fees",
      "exchange_rate": "$exchangeRate",
      "phone": phone,
      "providers": jsonEncode(Provider.toJsonArray(providers)),
      "lat": latLng.latitude.toString(),
      "lng": latLng.longitude.toString(),
      "distance": "0",
      "ads_user_id": adsUserId,
      "ads_device_id": adsDeviceId,
      "ads_user": jsonEncode(adsUser!.toJson()),
      "status": "$status"
    };
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
  ImageUrl? image;
  ImageUrl? marker;
  ImageUrl? icon;
  String? color;

  Provider(
      {required this.id,
      required this.name,
      this.image,
      this.marker,
      this.icon,
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
        'image': ImageUrl.toJson(providers[i].image!),
        'icon': ImageUrl.toJson(providers[i].icon!),
        'marker': ImageUrl.toJson(providers[i].marker!),
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
