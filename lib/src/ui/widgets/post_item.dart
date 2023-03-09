// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/models/exchange.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../blocs/post_bloc.dart';
import '../../utils/myan_number.dart';
import '../chat_page.dart';
import '../../models/post.dart';
import '../../utils/map_util.dart';
import '../entry/create_post_page.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final Function? onUpdated;
  final Function? onDeleted;
  const PostItem(
      {super.key, required this.post, this.onUpdated, this.onDeleted});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final PostBloc postBloc = PostBloc();
  final ExchangeBloc exchangeBloc = ExchangeBloc();

  bool isLoading = false;

  void onContact() async {
    try {
      if (isLoading) return;
      setState(() {
        isLoading = true;
      });
      final navigator = Navigator.of(context);

      List<Exchange> existExchange = await exchangeBloc.checkExchangeExist(
          widget.post.id.toString(), AppConstant.firebaseUser!.uid);
      if (existExchange.isEmpty) {
        var meta = <String, dynamic>{};
        meta["post_id"] = widget.post.id;
        meta["phone"] = widget.post.phone;
        meta["amount"] = widget.post.amount;

        var room = await FirebaseChatCore.instance
            .createRoom(types.User(id: widget.post.adsUserId), metadata: meta);
        await exchangeBloc.createExchange({
          "ads_post_id": widget.post.id.toString(),
          "ads_user_id": widget.post.adsUserId.toString(),
          "ex_user_id": AppConstant.firebaseUser!.uid,
          "ex_device_id": await PlatformDeviceId.getDeviceId,
          "room_id": room.id,
          "amount": "0",
          "status": "initiated"
        });
        await navigator.push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
                room: types.Room(
                    id: room.id,
                    name: widget.post.phone,
                    users: [
                      types.User(id: widget.post.adsUserId),
                      types.User(id: AppConstant.firebaseUser!.uid)
                    ],
                    type: types.RoomType.direct)),
          ),
        );
      } else {
        await navigator.push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
              room: types.Room(
                  id: existExchange[0].roomId,
                  name: existExchange[0].post!.phone,
                  users: [
                    types.User(id: existExchange[0].adsUserId),
                    types.User(id: existExchange[0].exUserId)
                  ],
                  type: types.RoomType.direct),
            ),
          ),
        );
      }
      await FirebaseAnalytics.instance.logEvent(
        name: "try_contact",
        parameters: {},
      );
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
    }
  }

  void onDelete() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.black,
                      ))),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              if (isLoading) return;
              setState(() {
                isLoading = true;
              });
              String deletedPost =
                  await postBloc.deleteAdsPost(widget.post.id.toString());
              Fluttertoast.showToast(
                  msg: jsonDecode(deletedPost)["message"],
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
                )),
        title: Text(
          AppLocalizations.of(context)!.confirm,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: widget.post.priority! > 0 ? Colors.yellow.shade200 : Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              ListTile(
                title: widget.post.adsUserId != AppConstant.firebaseUser!.uid
                    ? Row(
                        children: [
                          if (widget.post.providers.length > 1)
                            Text("ယူ ${widget.post.providers[1].name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black, fontSize: 16)),
                          if (widget.post.providers.length > 1)
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.swap_horiz,
                                    color: Colors.black, size: 22)),
                          Text("ပေး ${widget.post.providers[0].name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black, fontSize: 16))
                        ],
                      )
                    : Row(
                        children: [
                          Text("ယူ ${widget.post.providers[0].name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black, fontSize: 16)),
                          if (widget.post.providers.length > 1)
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.swap_horiz,
                                    color: Colors.black, size: 22)),
                          if (widget.post.providers.length > 1)
                            Text("ပေး ${widget.post.providers[1].name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black, fontSize: 16))
                        ],
                      ),
                subtitle: Text(
                    widget.post.chargesType == 'percentage'
                        ? "${MyanNunber.convertNumber(widget.post.percentage.toString())} ${AppLocalizations.of(context)!.percentage}"
                        : "${MyanNunber.convertMoneyNumber(widget.post.fees)} ${AppLocalizations.of(context)!.fixed_amount}",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.black87,
                        )),
                // leading: Image(
                //     image: CachedNetworkImageProvider(
                //         widget.post.providers[0].image.url),
                //     width: 50,
                //     height: 50),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 130,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.amount,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Colors.black45,
                                ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                  MyanNunber.convertMoneyNumber(
                                      widget.post.amount),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Colors.black,
                                      )))
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (widget.post.adsUserId !=
                              AppConstant.firebaseUser!.uid)
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade500,
                                borderRadius: BorderRadius.circular(36),
                              ),
                              height: 36,
                              width: 36,
                              child: InkWell(
                                onTap: () {
                                  MapUtils.openMap(widget.post.latLng.latitude,
                                      widget.post.latLng.longitude);
                                },
                                borderRadius: BorderRadius.circular(36),
                                child: const Icon(Icons.directions,
                                    size: 24, color: Colors.white),
                              ),
                            )
                          else
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: Colors.red.shade500,
                                borderRadius: BorderRadius.circular(36),
                              ),
                              height: 36,
                              width: 36,
                              child: InkWell(
                                onTap: () {
                                  onDelete();
                                },
                                borderRadius: BorderRadius.circular(36),
                                child: const Icon(Icons.delete,
                                    size: 24, color: Colors.white),
                              ),
                            ),
                          if (widget.post.adsUserId !=
                              AppConstant.firebaseUser!.uid)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green.shade500,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              height: 36,
                              width: 36,
                              child: InkWell(
                                onTap: () {
                                  onContact();
                                },
                                borderRadius: BorderRadius.circular(36),
                                child: const Icon(Icons.message,
                                    size: 22, color: Colors.white),
                              ),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.orange.shade500,
                                borderRadius: BorderRadius.circular(32),
                              ),
                              height: 36,
                              width: 36,
                              child: InkWell(
                                onTap: () async {
                                  String updated = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CreatePostPage(post: widget.post)),
                                  );
                                  if (updated == "_createdPost" &&
                                      widget.onUpdated != null) {
                                    widget.onUpdated!();
                                  }
                                },
                                borderRadius: BorderRadius.circular(36),
                                child: const Icon(Icons.edit,
                                    size: 22, color: Colors.white),
                              ),
                            )
                        ],
                      ))
                ],
              )
            ],
          )),
    );
  }
}
