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

  static Future<void> updateUserOnline(
      String roomId, String userId, bool isOnline) {
    return getFirebaseFirestore()
        .collection(config.usersCollectionName)
        .doc(userId)
        .update({'isOnline': isOnline, 'lastSeenRoom': roomId});
  }

  static Future<void> updatePostId(String roomId, String postId) {
    return getFirebaseFirestore()
        .collection(config.roomsCollectionName)
        .doc(roomId)
        .update({'metadata.post_id': postId});
  }

  static Future<void> createUserInFirestore(dynamic user) async {
    await getFirebaseFirestore()
        .collection(config.usersCollectionName)
        .doc(user.id)
        .set({
      'createdAt': FieldValue.serverTimestamp(),
      'name': user.name,
      'phone': user.phone,
      'imageUrl': user.imageUrl,
      'lastSeen': FieldValue.serverTimestamp(),
      'metadata': user.metadata,
      'role': user.role?.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
      'darkMode': false
    });
  }
}
