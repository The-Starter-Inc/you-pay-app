import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/models/exchange.dart';
import 'package:p2p_pay/src/ui/widgets/ripples_animation%20.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import '../../firebase_options.dart';
import 'chat_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPagetate();
}

class _NotificationPagetate extends State<NotificationPage> {
  ExchangeBloc exchangeBloc = ExchangeBloc();

  @override
  void initState() {
    super.initState();
    exchangeBloc.fetchExchages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Notification")),
        //body: const RipplesAnimation(),
        body: StreamBuilder<List<Exchange>>(
          stream: exchangeBloc.exchange,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final exchange = snapshot.data![index];

                  return GestureDetector(
                    onTap: () async {
                      FirebaseChatCoreConfig config =
                          const FirebaseChatCoreConfig(
                        null,
                        'rooms',
                        'users',
                      );
                      FirebaseFirestore getFirebaseFirestore() =>
                          config.firebaseAppName != null
                              ? FirebaseFirestore.instanceFor(
                                  app: Firebase.app(config.firebaseAppName!),
                                )
                              : FirebaseFirestore.instance;
                      final otherUser = await fetchUser(
                        getFirebaseFirestore(),
                        exchange.post!.firebaseUserId,
                        config.usersCollectionName,
                      );

                      final room = await getFirebaseFirestore()
                          .collection("rooms")
                          .doc(exchange.roomId!)
                          .get();
                      print(room.data());
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatPage(
                            room: types.Room.fromJson(room.data()!),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      child: Row(
                        children: [
                          Text(exchange.exDeviceId,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.black,
                                  )),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ));
  }

  Widget _buildAvatarRoom(types.Room room) {
    var color = Colors.transparent;

    if (room.type == types.RoomType.direct) {
      try {
        final otherUser = room.users.firstWhere(
          (u) => u.id != AppConstant.firebaseUser!.uid,
        );

        color = Colors.pinkAccent;
      } catch (e) {
        // Do nothing if other user is not found.
      }
    }

    final hasImage = room.imageUrl != null;
    final name = room.name ?? '';

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(room.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  Widget _buildAvatarUser(types.User user) {
    final color = Colors.pinkAccent;
    final hasImage = user.imageUrl != null;
    final name = "${user.firstName} ${user.lastName}";

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: CircleAvatar(
        backgroundColor: hasImage ? Colors.transparent : color,
        backgroundImage: hasImage ? NetworkImage(user.imageUrl!) : null,
        radius: 20,
        child: !hasImage
            ? Text(
                name.isEmpty ? '' : name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              )
            : null,
      ),
    );
  }

  void _handlePressed(types.User otherUser, BuildContext context) async {
    final navigator = Navigator.of(context);
    final room = await FirebaseChatCore.instance.createRoom(otherUser);

    await navigator.push(
      MaterialPageRoute(
        builder: (context) => ChatPage(
          room: room,
        ),
      ),
    );
  }
}
