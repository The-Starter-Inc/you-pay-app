// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/models/exchange.dart';
import '../../constants/app_constant.dart';
import '../../utils/myan_number.dart';
import '../chat_page.dart';

// ignore: must_be_immutable
class NotificationItem extends StatefulWidget {
  final Exchange exchange;
  late bool? hasNotification;
  final Function? onClick;
  NotificationItem(
      {super.key, required this.exchange, this.hasNotification, this.onClick});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  final ExchangeBloc exchangeBloc = ExchangeBloc();
  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.hasNotification! ? Colors.yellow.shade200 : Colors.white,
        margin: const EdgeInsets.only(bottom: 0),
        child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: GestureDetector(
                onTap: () async {
                  try {
                    final notifications = await Localstore.instance
                        .collection('notifications')
                        .get();
                    if (notifications != null) {
                      notifications.forEach((key, value) {
                        RemoteMessage message = RemoteMessage.fromMap(value);
                        final metadata = jsonDecode(message.data['metadata']);
                        if ("${metadata['post_id']}" ==
                            "${widget.exchange.adsPostId}") {
                          Localstore.instance
                              .collection('notifications')
                              .doc(message.messageId)
                              .delete();
                        }
                      });
                      setState(() {
                        widget.hasNotification = false;
                        widget.onClick!();
                      });
                    }
                    // ignore: use_build_context_synchronously
                    final navigator = Navigator.of(context);
                    await navigator.push(
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          postId: widget.exchange.post!.id,
                          room: types.Room(
                              id: widget.exchange.roomId,
                              name: widget.exchange.post!.phone,
                              users: [
                                types.User(id: widget.exchange.adsUserId),
                                types.User(id: widget.exchange.exUserId)
                              ],
                              type: types.RoomType.direct),
                        ),
                      ),
                    );
                  } catch (e) {
                    debugPrint(e.toString());
                  }
                },
                child: Column(
                  children: [
                    ListTile(
                        title: widget.exchange.post!.adsUserId !=
                                AppConstant.firebaseUser!.uid
                            ? Row(
                                children: [
                                  if (widget.exchange.post!.providers.length >
                                      1)
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          height: 32,
                                          width: 32,
                                          child: const Center(
                                              child: Text("ယူ",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12))),
                                        ),
                                        Text(
                                            widget.exchange.post!.providers[1]
                                                .name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 16))
                                      ],
                                    ),
                                  if (widget.exchange.post!.providers.length >
                                      1)
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Icon(Icons.swap_horiz,
                                            color: Colors.black, size: 22)),
                                  Row(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.black45,
                                          borderRadius:
                                              BorderRadius.circular(32),
                                        ),
                                        height: 32,
                                        width: 32,
                                        child: const Center(
                                            child: Text("ပေး",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12))),
                                      ),
                                      Text(
                                          widget
                                              .exchange.post!.providers[0].name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 16))
                                    ],
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  Row(children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      height: 32,
                                      width: 32,
                                      child: const Center(
                                          child: Text("ယူ",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12))),
                                    ),
                                    Text(
                                        widget.exchange.post!.providers[0].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 16)),
                                  ]),
                                  if (widget.exchange.post!.providers.length >
                                      1)
                                    const Padding(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 4),
                                        child: Icon(Icons.swap_horiz,
                                            color: Colors.black, size: 22)),
                                  if (widget.exchange.post!.providers.length >
                                      1)
                                    Row(
                                      children: [
                                        Container(
                                          margin:
                                              const EdgeInsets.only(right: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius:
                                                BorderRadius.circular(32),
                                          ),
                                          height: 32,
                                          width: 32,
                                          child: const Center(
                                              child: Text("ပေး",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12))),
                                        ),
                                        Text(
                                            widget.exchange.post!.providers[1]
                                                .name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 16))
                                      ],
                                    )
                                ],
                              ),
                        subtitle: Text(
                            widget.exchange.post!.chargesType == 'percentage'
                                ? "${MyanNunber.convertNumber(widget.exchange.post!.percentage.toString())} ${AppLocalizations.of(context)!.percentage}"
                                : "${MyanNunber.convertMoneyNumber(widget.exchange.post!.fees)} ${AppLocalizations.of(context)!.mmk} ${AppLocalizations.of(context)!.fixed_amount}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black87,
                                )),
                        trailing: widget.hasNotification!
                            ? const Icon(Icons.circle,
                                size: 10, color: Colors.red)
                            : null)
                  ],
                ))));
  }
}
