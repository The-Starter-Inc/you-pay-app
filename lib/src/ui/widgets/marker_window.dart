// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:p2p_pay/src/theme/color_theme.dart';
import '../../blocs/exchange_bloc.dart';
import '../../blocs/post_bloc.dart';
import '../../constants/app_constant.dart';
import '../../models/exchange.dart';
import '../../models/post.dart';
import '../../utils/map_util.dart';
import '../chat_page.dart';
import '../entry/create_post_page.dart';

class MarkerWindow extends StatefulWidget {
  final Post post;
  final Function? onUpdated;
  final Function? onDeleted;
  final CustomInfoWindowController infoWindowController;

  const MarkerWindow(
      {super.key,
      required this.post,
      required this.infoWindowController,
      this.onUpdated,
      this.onDeleted});

  @override
  State<MarkerWindow> createState() => _MarkerWindowState();
}

class _MarkerWindowState extends State<MarkerWindow> {
  final PostBloc postBloc = PostBloc();
  final ExchangeBloc exchangeBloc = ExchangeBloc();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            width: double.infinity,
            height: double.maxFinite,
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          widget.infoWindowController.hideInfoWindow!();
                        },
                        child: const Icon(Icons.close,
                            size: 18, color: Colors.black45),
                      ),
                    ),
                    Center(
                      child: Image(
                          image: CachedNetworkImageProvider(
                              widget.post.adsUserId !=
                                      AppConstant.firebaseUser!.uid
                                  ? widget.post.providers[1].image.url
                                  : widget.post.providers[0].image.url),
                          width: 50,
                          height: 50),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        widget.post.adsUserId != AppConstant.firebaseUser!.uid
                            ? "${widget.post.providers[1].name} ယူ"
                            : "${widget.post.providers[0].name} ယူ",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.pay,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          widget.post.adsUserId != AppConstant.firebaseUser!.uid
                              ? widget.post.providers[0].name
                              : widget.post.providers[1].name,
                          textAlign: TextAlign.right,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.amount,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          widget.post.amount.toString(),
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.post.chargesType == 'percentage'
                              ? AppLocalizations.of(context)!.percentage
                              : AppLocalizations.of(context)!.fixed_amount,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          widget.post.chargesType == 'percentage'
                              ? "${widget.post.percentage}%"
                              : "${widget.post.fees}",
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.phone,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          widget.post.phone,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.distance,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "${widget.post.distance}km",
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.post.adsUserId !=
                            AppConstant.firebaseUser!.uid)
                          OutlinedButton(
                            onPressed: () {
                              MapUtils.openMap(widget.post.latLng.latitude,
                                  widget.post.latLng.longitude);
                            },
                            child: const Icon(Icons.directions, size: 24),
                          )
                        else
                          OutlinedButton(
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancel,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
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
                                            await postBloc.deleteAdsPost(
                                                widget.post.id.toString());
                                        Fluttertoast.showToast(
                                            msg: jsonDecode(
                                                deletedPost)["message"],
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        setState(() {
                                          isLoading = false;
                                        });
                                        widget.onDeleted!();
                                      },
                                      child: Text(
                                          AppLocalizations.of(context)!.delete),
                                    ),
                                  ],
                                  content: Text(
                                      AppLocalizations.of(context)!
                                          .delete_confirm_msg,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            color: Colors.black,
                                          )),
                                  title: Text(
                                    AppLocalizations.of(context)!.confirm,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                ),
                              );
                            },
                            child: Text(AppLocalizations.of(context)!.delete),
                          ),
                        const SizedBox(width: 16),
                        if (widget.post.adsUserId !=
                            AppConstant.firebaseUser!.uid)
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  isLoading
                                      ? Colors.black45
                                      : AppColor.secondaryColor),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  isLoading
                                      ? Colors.black45
                                      : AppColor.secondaryColor),
                            ),
                            onPressed: () async {
                              try {
                                if (isLoading) return;
                                setState(() {
                                  isLoading = true;
                                });

                                final navigator = Navigator.of(context);

                                List<Exchange> existExchange =
                                    await exchangeBloc.checkExchangeExist(
                                        widget.post.id.toString(),
                                        AppConstant.firebaseUser!.uid);
                                if (existExchange.isEmpty) {
                                  var meta = <String, dynamic>{};
                                  meta["post_id"] = widget.post.id;
                                  meta["phone"] = widget.post.phone;
                                  meta["amount"] = widget.post.amount;
                                  final room = await FirebaseChatCore.instance
                                      .createRoom(
                                          types.User(id: widget.post.adsUserId),
                                          metadata: meta);

                                  await exchangeBloc.createExchange({
                                    "ads_post_id": widget.post.id.toString(),
                                    "ads_user_id":
                                        widget.post.adsUserId.toString(),
                                    "ex_user_id": AppConstant.firebaseUser!.uid,
                                    "ex_device_id":
                                        await PlatformDeviceId.getDeviceId,
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
                                                types.User(
                                                    id: widget.post.adsUserId),
                                                types.User(
                                                    id: AppConstant
                                                        .firebaseUser!.uid)
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
                                              types.User(
                                                  id: existExchange[0]
                                                      .adsUserId),
                                              types.User(
                                                  id: existExchange[0].exUserId)
                                            ],
                                            type: types.RoomType.direct),
                                      ),
                                    ),
                                  );
                                }
                                setState(() {
                                  isLoading = false;
                                });
                              } catch (e) {
                                setState(() {
                                  isLoading = false;
                                });
                                debugPrint(e.toString());
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.contact,
                                style: const TextStyle(color: Colors.white)),
                          )
                        else
                          OutlinedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  isLoading
                                      ? Colors.black45
                                      : AppColor.secondaryColor),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  isLoading
                                      ? Colors.black45
                                      : AppColor.secondaryColor),
                            ),
                            onPressed: () async {
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
                            child: Text(AppLocalizations.of(context)!.edit,
                                style: const TextStyle(color: Colors.white)),
                          )
                      ],
                    )
                  ],
                )),
          ),
        ),
        Triangle.isosceles(
          edge: Edge.BOTTOM,
          child: Container(
            color: Colors.white,
            width: 20.0,
            height: 10.0,
          ),
        ),
      ],
    );
  }
}
