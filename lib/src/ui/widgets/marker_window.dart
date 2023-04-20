// ignore_for_file: depend_on_referenced_packages

import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:p2p_pay/src/theme/color_theme.dart';
import '../../blocs/exchange_bloc.dart';
import '../../blocs/post_bloc.dart';
import '../../constants/app_constant.dart';
import '../../models/exchange.dart';
import '../../models/post.dart';
import '../../utils/map_util.dart';
import '../chat_page.dart';

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
                    if (widget.post.adsUser != null)
                      Center(
                        child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: AppColor.primaryLight,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                              child: Text(widget.post.adsUser!.name![0],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.black)),
                            )),
                      ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        widget.post.adsUser!.name!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                      ),
                    ),
                    if (widget.post.providers.isNotEmpty)
                      const SizedBox(height: 10),
                    if (widget.post.providers.isNotEmpty)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.you,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Colors.black,
                                ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Text(
                            widget.post.providers[1].name,
                            textAlign: TextAlign.right,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium!
                                .copyWith(
                                  color: Colors.black45,
                                ),
                          ),
                        ],
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
                          widget.post.providers[0].name,
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
                              : widget.post.chargesType == 'fix_amount'
                                  ? AppLocalizations.of(context)!.fixed_amount
                                  : AppLocalizations.of(context)!.exchange_rate,
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
                              : widget.post.chargesType == 'fix_amount'
                                  ? "${widget.post.fees} ${AppLocalizations.of(context)!.mmk}"
                                  : "${widget.post.exchangeRate} ${AppLocalizations.of(context)!.mmk}",
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
                    // const SizedBox(height: 5),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text(
                    //       AppLocalizations.of(context)!.distance,
                    //       style:
                    //           Theme.of(context).textTheme.labelMedium!.copyWith(
                    //                 color: Colors.black,
                    //               ),
                    //     ),
                    //     const SizedBox(
                    //       width: 8.0,
                    //     ),
                    //     Text(
                    //       "${widget.post.distance}km",
                    //       style:
                    //           Theme.of(context).textTheme.labelMedium!.copyWith(
                    //                 color: Colors.black45,
                    //               ),
                    //     )
                    //   ],
                    // ),
                    //
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            MapUtils.openMap(widget.post.latLng.latitude,
                                widget.post.latLng.longitude);
                          },
                          child: const Icon(Icons.directions, size: 24),
                        ),
                        const SizedBox(width: 16),
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
                              if (widget.post.adsUserId ==
                                  AppConstant.firebaseUser!.uid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .can_not_contact)));
                                return;
                              }
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
                                        postId: widget.post.id,
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
                                      postId: existExchange[0].post!.id,
                                      room: types.Room(
                                          id: existExchange[0].roomId,
                                          name: existExchange[0].post!.phone,
                                          users: [
                                            types.User(
                                                id: existExchange[0].adsUserId),
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
