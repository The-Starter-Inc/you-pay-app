// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/models/exchange.dart';
import 'package:p2p_pay/src/ui/feedbacks_page.dart';
import 'package:p2p_pay/src/utils/alert_util.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../blocs/post_bloc.dart';
import '../../theme/color_theme.dart';
import '../../utils/myan_number.dart';
import '../chat_page.dart';
import '../../models/post.dart';

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

  @override
  void initState() {
    super.initState();
  }

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
          "ads_user": widget.post.adsUser != null
              ? jsonEncode(widget.post.adsUser!.toJson())
              : null,
          "ex_user_id": AppConstant.firebaseUser!.uid,
          "ex_user": jsonEncode(AppConstant.currentUser!.toJson()),
          "ex_device_id": await PlatformDeviceId.getDeviceId,
          "room_id": room.id,
          "amount": "0",
          "status": "initiated"
        });
        await navigator.push(
          MaterialPageRoute(
            builder: (context) => ChatPage(
                postId: widget.post.id,
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
              postId: widget.post.id,
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
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
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
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold
            )),
        title: Text(
          AppLocalizations.of(context)!.confirm,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        margin: const EdgeInsets.only(bottom: 0),
        //color: widget.post.priority! > 0 ? Colors.yellow.shade200 : Colors.white,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.post.adsUser != null)
                      Container(
                          margin:
                          const EdgeInsets.only(left: 16, right: 16, top: 10),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FeedbacksPage(
                                          user: widget.post.adsUser!)),
                                );
                              },
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
                                        child: Text(widget.post.adsUser!.name![0],
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                            )),
                                      )),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.post.adsUser!.name!,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          )),
                                      Text(
                                          widget.post.priority != null &&
                                              widget.post.priority! > 0
                                              ? "Verified"
                                              : "Unverified",
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold
                                          ))
                                    ],
                                  )
                                ],
                              )))
                    else
                      const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 16, right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    "${MyanNunber.convertMoneyNumber(widget.post.amount)} ${AppLocalizations.of(context)!.mmk}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    )),
                                Text(
                                    widget.post.chargesType == 'percentage'
                                        ? "${MyanNunber.convertNumber(widget.post.percentage.toString())} ${AppLocalizations.of(context)!.percentage}"
                                        : widget.post.chargesType == 'fix_amount'
                                        ? "${MyanNunber.convertMoneyNumber(widget.post.fees)} ${AppLocalizations.of(context)!.mmk} ${AppLocalizations.of(context)!.fixed_amount}"
                                        : "${MyanNunber.convertMoneyNumber(widget.post.exchangeRate)} ${AppLocalizations.of(context)!.mmk} ${AppLocalizations.of(context)!.exchange_rate}",
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    ))
                              ],
                            )),
                      ],
                    ),
                    Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.post.providers.length > 1)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.you,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                      )),
                                  Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 16,
                                        margin: const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            color: Color(int.parse(
                                                widget.post.providers[1].color ??
                                                    "0xFFCCCCCC"))),
                                      ),
                                      Text(widget.post.providers[1].name,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                          ))
                                    ],
                                  )
                                ],
                              ),
                            if (widget.post.providers.length > 1)
                              Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
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
                                      const Icon(Icons.swap_horiz,  size: 22)
                                    ],
                                  )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.pay,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                    )),
                                Row(
                                  children: [
                                    Container(
                                      width: 3,
                                      height: 16,
                                      margin: const EdgeInsets.only(right: 10),
                                      decoration: BoxDecoration(
                                          color: Color(int.parse(
                                              widget.post.providers[0].color ??
                                                  "0xFFCCCCCC"))),
                                    ),
                                    Text(widget.post.providers[0].name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold
                                        ))
                                  ],
                                )
                              ],
                            )
                          ],
                        ))
                  ],
                ),
                if (widget.post.priority != null && widget.post.priority! > 0)
                  Positioned(
                      top: 8,
                      right: 16,
                      child: Image.asset("assets/images/trusted.png", width: 55)),
                Positioned(
                    top: 80,
                    right: 16,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (widget.post.adsUserId !=
                            AppConstant.firebaseUser!.uid) {
                          onContact();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .can_not_contact)));
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              AppColor.secondaryColor),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              AppColor.secondaryColor),
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32.0),
                              ))),
                      child: Text(AppLocalizations.of(context)!.contact,
                          style:
                          const TextStyle(color: Colors.white, fontSize: 14)),
                    ))
              ],
            )),
      ),
    );
  }
}
