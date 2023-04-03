// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../theme/color_theme.dart';
import './../constants/app_constant.dart';
import './../models/exchange.dart';
import 'widgets/exchange_item.dart';

class ExchangePage extends StatefulWidget {
  const ExchangePage({super.key});

  @override
  State<ExchangePage> createState() => _ExchangePagetate();
}

class _ExchangePagetate extends State<ExchangePage> {
  ExchangeBloc exchangeBloc = ExchangeBloc();
  late Map<String, dynamic>? notifications;

  @override
  void initState() {
    super.initState();
    initData();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Exchange Page");
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
            title: Text(AppLocalizations.of(context)!.exchange_money,),),
        //body: const RipplesAnimation(),
        body: StreamBuilder<List<Exchange>>(
          stream: exchangeBloc.exchange,
          initialData: const [],
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.no_data,
                        style: const TextStyle(
                            fontSize: 16,
                        )));
              }

              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final exchange = snapshot.data![index];
                  var hasNotification = false;
                  if (notifications != null &&
                      notifications!.keys
                          .where((key) =>
                              notifications![key]['data']['type'] == 'message')
                          .isNotEmpty) {
                    notifications!.forEach((key, value) {
                      RemoteMessage message = RemoteMessage.fromMap(value);
                      if (message.data['metadata'] != null) {
                        final metadata = jsonDecode(message.data['metadata']);
                        if ("${metadata['post_id']}" ==
                            "${exchange.adsPostId}") {
                          hasNotification = true;
                        }
                      }
                    });
                  }
                  return ExchangeItem(
                      exchange: exchange,
                      hasNotification: hasNotification,
                      onClick: () async {
                        notifications = await Localstore.instance
                            .collection('notifications')
                            .get();
                      },
                      onDeleted: () {
                        exchangeBloc
                            .fetchExchages(AppConstant.firebaseUser!.uid);
                      });
                },
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString(),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                  ));
            }
            return Center(
                child: Image.asset("assets/images/loading.gif", width: 100));
          },
        ));
  }
}
