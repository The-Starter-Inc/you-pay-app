// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/general_noti_bloc.dart';
import 'package:p2p_pay/src/models/general_noti.dart';
import '../theme/color_theme.dart';
import '../ui/widgets/notification_item.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPagetate();
}

class _NotificationPagetate extends State<NotificationPage> {
  GeneralNotiBloc generalNotiBloc = GeneralNotiBloc();
  late Map<String, dynamic>? notifications;

  @override
  void initState() {
    super.initState();
    initData();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "Notification Page");
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   if (message.data['type'] == 'contact') {
    //     exchangeBloc.fetchExchages(AppConstant.firebaseUser!.uid);
    //   } else {
    //     initData();
    //   }
    // });
  }

  void initData() async {
    notifications = await Localstore.instance.collection('notifications').get();
    generalNotiBloc.fetchSGeneralNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.notifications),
            ),
        //body: const RipplesAnimation(),
        body: StreamBuilder<List<GeneralNoti>>(
          stream: generalNotiBloc.generalNotis,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.no_data,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final generalNoti = snapshot.data![index];
                  var hasNotification = false;
                  if (notifications != null &&
                      notifications!.keys
                          .where((key) => notifications![key] != 'message')
                          .isNotEmpty) {
                    notifications!.forEach((key, value) {
                      RemoteMessage message = RemoteMessage.fromMap(value);
                      if ("${message.notification!.android!.tag}" ==
                          "topic_key_${generalNoti.messageId}") {
                        hasNotification = true;
                      }
                    });
                  }
                  return NotificationItem(
                      generalNoti: generalNoti,
                      hasNotification: hasNotification,
                      onClick: () async {
                        notifications = await Localstore.instance
                            .collection('notifications')
                            .get();
                      });
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  ));
            }
            return Center(
                child: Image.asset("assets/images/loading.gif", width: 100));
          },
        ));
  }
}
