// ignore: depend_on_referenced_packages
import 'package:event/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './../../src/models/post_event.dart';

class AppConstant {
  AppConstant._();

  // Dev
  // static String host = "https://youpay.apitoolz.com";
  // static String clientId = "1";
  // static String clientSecret = "hrZUCdlnUjTyL9dV0Vxqwl4EoBXVXUSRH4qF8H14";

  //Prod
  static String host = "https://dd4nafnexkyxt.cloudfront.net";
  static String clientId = "3";
  static String clientSecret = "R2ojjucelPZs8QLgY66N5ZeL6hYkrRfCIgYL7MSh";

  static String? accessToken;
  static User? firebaseUser;
  static bool hasNotification = false;
  static var postCreated = Event<PostEvent>();
}
