// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/color_theme.dart';
import '../ui/widgets/notification_item.dart';
import './../constants/app_constant.dart';
import './../models/exchange.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPagetate();
}

class _NotificationPagetate extends State<NotificationPage> {
  ExchangeBloc exchangeBloc = ExchangeBloc();
  late Map<String, dynamic>? notifications;

  @override
  void initState() {
    super.initState();
    initData();
    FirebaseAnalytics.instance
        .setCurrentScreen(screenName: "Notification Page");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'contact') {
        exchangeBloc.fetchExchages(AppConstant.firebaseUser!.uid);
      } else {
        initData();
      }
    });
  }

  void initData() async {
    notifications = await Localstore.instance.collection('notifications').get();
    exchangeBloc.fetchExchages(AppConstant.firebaseUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.notifications),
            backgroundColor: AppColor.primaryColor),
        //body: const RipplesAnimation(),
        body: StreamBuilder<List<Exchange>>(
          stream: exchangeBloc.exchange,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.no_data,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black45)));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final exchange = snapshot.data![index];
                  var hasNotification = false;
                  if (notifications != null && notifications!.isNotEmpty) {
                    notifications!.forEach((key, value) {
                      RemoteMessage message = RemoteMessage.fromMap(value);
                      final metadata = jsonDecode(message.data['metadata']);
                      if ("${metadata['post_id']}" == "${exchange.adsPostId}") {
                        hasNotification = true;
                      }
                    });
                  }
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: NotificationItem(
                          exchange: exchange,
                          hasNotification: hasNotification,
                          onClick: () async {
                            notifications = await Localstore.instance
                                .collection('notifications')
                                .get();
                          }));
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.black45));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
