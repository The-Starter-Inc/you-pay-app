// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/models/exchange.dart';
import '../../blocs/post_bloc.dart';
import '../../utils/myan_number.dart';
import '../chat_page.dart';

class ExchangeItem extends StatefulWidget {
  final Exchange exchange;
  final Function? onDeleted;
  late bool? hasNotification;
  final Function? onClick;
  ExchangeItem(
      {super.key,
      required this.exchange,
      this.hasNotification,
      this.onDeleted,
      this.onClick});

  @override
  State<ExchangeItem> createState() => _ExchangeItemState();
}

class _ExchangeItemState extends State<ExchangeItem> {
  final PostBloc postBloc = PostBloc();
  final ExchangeBloc exchangeBloc = ExchangeBloc();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void deleteExchange() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.cancel,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black,
                                ))),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    if (isLoading) return;
                    setState(() {
                      isLoading = true;
                    });
                    String deletedEx = await exchangeBloc
                        .deleteExchange(widget.exchange.id.toString());
                    Fluttertoast.showToast(
                        msg: jsonDecode(deletedEx)["message"],
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.CENTER,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    setState(() {
                      isLoading = false;
                    });
                    widget.onDeleted!();
                  },
                  child: Text(AppLocalizations.of(context)!.delete),
                ),
              ],
              content: Text(AppLocalizations.of(context)!.delete_confirm_msg,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                        fontFamily: 'Pyidaungsu',
                      )),
              title: Text(
                AppLocalizations.of(context)!.confirm,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.black,
                      fontFamily: 'Pyidaungsu',
                    ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          try {
            final notifications =
                await Localstore.instance.collection('notifications').get();
            if (notifications != null &&
                notifications.keys
                    .where((key) =>
                        notifications[key]['data']['type'] == 'message')
                    .isNotEmpty) {
              notifications.forEach((key, value) {
                RemoteMessage message = RemoteMessage.fromMap(value);
                if (message.data['metadata'] != null) {
                  final metadata = jsonDecode(message.data['metadata']);
                  if ("${metadata['post_id']}" ==
                      "${widget.exchange.adsPostId}") {
                    Localstore.instance
                        .collection('notifications')
                        .doc(message.messageId)
                        .delete();
                  }
                }
              });
              setState(() {
                widget.hasNotification = false;
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
        child: Container(
          margin: const EdgeInsets.only(bottom: 0),
          decoration: BoxDecoration(
              color: widget.hasNotification! ? Colors.yellow.shade100 : null,
              border: const Border(bottom: BorderSide(color: Colors.black12))),
          child: Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.exchange.adsUser != null)
                        Container(
                            margin: const EdgeInsets.only(
                                left: 16, right: 16, top: 10),
                            child: Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    margin: const EdgeInsets.only(right: 16),
                                    decoration: BoxDecoration(
                                      color: Colors.yellow.shade200,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(46)),
                                    ),
                                    child: Center(
                                      child: Text(
                                          widget.exchange.adsUser!.id !=
                                                  AppConstant.currentUser!.id
                                              ? widget
                                                  .exchange.adsUser!.name![0]
                                              : widget
                                                  .exchange.exUser!.name![0],
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(color: Colors.black)),
                                    )),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        widget.exchange.adsUser!.id !=
                                                AppConstant.currentUser!.id
                                            ? widget.exchange.adsUser!.name!
                                            : widget.exchange.exUser!.name!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 16)),
                                    Text(
                                        widget.exchange.post!.priority !=
                                                    null &&
                                                widget.exchange.post!
                                                        .priority! >
                                                    0
                                            ? "Verified"
                                            : "Unverified",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .copyWith(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12))
                                  ],
                                )
                              ],
                            ))
                      else
                        const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${MyanNunber.convertMoneyNumber(widget.exchange.post!.amount)} ${AppLocalizations.of(context)!.mmk}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16)),
                                  Text(
                                      widget.exchange.post!.chargesType ==
                                              'percentage'
                                          ? "${MyanNunber.convertNumber(widget.exchange.post!.percentage.toString())} ${AppLocalizations.of(context)!.percentage}"
                                          : widget.exchange.post!.chargesType ==
                                                  'fix_amount'
                                              ? "${MyanNunber.convertMoneyNumber(widget.exchange.post!.fees)} ${AppLocalizations.of(context)!.mmk} ${AppLocalizations.of(context)!.fixed_amount}"
                                              : "${MyanNunber.convertMoneyNumber(widget.exchange.post!.exchangeRate)} ${AppLocalizations.of(context)!.mmk} ${AppLocalizations.of(context)!.exchange_rate}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Colors.black87,
                                          ))
                                ],
                              )),
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 10),
                          child: widget.exchange.post!.adsUserId !=
                                  AppConstant.firebaseUser!.uid
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (widget.exchange.post!.providers.length >
                                        1)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!.you,
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.black87,
                                                  )),
                                          Row(
                                            children: [
                                              Container(
                                                width: 3,
                                                height: 16,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    color: Color(int.parse(
                                                        widget
                                                                .exchange
                                                                .post!
                                                                .providers[1]
                                                                .color ??
                                                            "0xFFCCCCCC"))),
                                              ),
                                              Text(
                                                  widget.exchange.post!
                                                      .providers[1].name,
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
                                    if (widget.exchange.post!.providers.length >
                                        1)
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Column(
                                            children: [
                                              Text(
                                                "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              const Icon(Icons.swap_horiz,
                                                  color: Colors.black, size: 22)
                                            ],
                                          )),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(AppLocalizations.of(context)!.pay,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: Colors.black87,
                                                )),
                                        Row(
                                          children: [
                                            Container(
                                              width: 3,
                                              height: 16,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  color: Color(int.parse(widget
                                                          .exchange
                                                          .post!
                                                          .providers[0]
                                                          .color ??
                                                      "0xFFCCCCCC"))),
                                            ),
                                            Text(
                                                widget.exchange.post!
                                                    .providers[0].name,
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
                                  ],
                                )
                              : Row(
                                  children: [
                                    if (widget.exchange.post!.providers.length >
                                        1)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!.you,
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.black87,
                                                  )),
                                          Row(children: [
                                            Container(
                                              width: 3,
                                              height: 16,
                                              margin: const EdgeInsets.only(
                                                  right: 10),
                                              decoration: BoxDecoration(
                                                  color: Color(int.parse(widget
                                                          .exchange
                                                          .post!
                                                          .providers[0]
                                                          .color ??
                                                      "0xFFCCCCCC"))),
                                            ),
                                            Text(
                                                widget.exchange.post!
                                                    .providers[0].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 16)),
                                          ]),
                                        ],
                                      ),
                                    if (widget.exchange.post!.providers.length >
                                        1)
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Column(
                                            children: [
                                              Text(
                                                "",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              const Icon(Icons.swap_horiz,
                                                  color: Colors.black, size: 22)
                                            ],
                                          )),
                                    if (widget.exchange.post!.providers.length >
                                        1)
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              AppLocalizations.of(context)!.pay,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                    color: Colors.black87,
                                                  )),
                                          Row(
                                            children: [
                                              Container(
                                                width: 3,
                                                height: 16,
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                decoration: BoxDecoration(
                                                    color: Color(int.parse(
                                                        widget
                                                                .exchange
                                                                .post!
                                                                .providers[1]
                                                                .color ??
                                                            "0xFFCCCCCC"))),
                                              ),
                                              Text(
                                                  widget.exchange.post!
                                                      .providers[1].name,
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
                                  ],
                                ))
                    ],
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: PopupMenuButton<int>(
                      elevation: 2,
                      child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                              child: Icon(
                            Icons.more_horiz,
                            size: 24,
                            color: Colors.black54,
                          ))),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 1,
                            padding: const EdgeInsets.all(0),
                            child: ListTile(
                              leading: const Icon(Icons.delete_forever_rounded,
                                  color: Colors.red),
                              title: Text(
                                AppLocalizations.of(context)!.delete,
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ),
                          )
                        ];
                      },
                      onSelected: (value) {
                        deleteExchange();
                      },
                    ),
                  )
                ],
              )),
        ));
  }
}
