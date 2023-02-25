// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseUtil {
  static FirebaseChatCoreConfig config = const FirebaseChatCoreConfig(
    null,
    'rooms',
    'users',
  );
  static getFirebaseFirestore() {
    return config.firebaseAppName != null
        ? FirebaseFirestore.instanceFor(
            app: Firebase.app(config.firebaseAppName!),
          )
        : FirebaseFirestore.instance;
  }
}
