// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  @override
  void initState() {
    super.initState();
    exchangeBloc.fetchExchages(AppConstant.firebaseUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: Text(AppLocalizations.of(context)!.notifications)),
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

                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: NotificationItem(exchange: exchange));
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
