// ignore_for_file: depend_on_referenced_packages

import 'package:clippy_flutter/triangle.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';
import '../../blocs/exchange_bloc.dart';
import '../../constants/app_constant.dart';
import '../../models/exchange.dart';
import '../../models/post.dart';
import '../../utils/map_util.dart';
import '../chat_page.dart';

class MarkerWindow extends StatefulWidget {
  final Post post;
  final CustomInfoWindowController infoWindowController;

  const MarkerWindow(
      {super.key, required this.post, required this.infoWindowController});

  @override
  State<MarkerWindow> createState() => _MarkerWindowState();
}

class _MarkerWindowState extends State<MarkerWindow> {
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
                      child: Image.network(widget.post.providers[0].image.url,
                          width: 50, height: 50),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        widget.post.providers[0].name,
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
                          AppLocalizations.of(context)!.type,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          widget.post.type.name,
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
                          AppLocalizations.of(context)!.percentage,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Text(
                          "${widget.post.percentage}%",
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
                                isLoading ? Colors.black45 : Colors.lightBlue),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                isLoading ? Colors.black45 : Colors.lightBlue),
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
                                final room = await FirebaseChatCore.instance
                                    .createRoom(
                                        types.User(id: widget.post.adsUserId));

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
                                    builder: (context) => ChatPage(room: room),
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
