// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import 'package:p2p_pay/src/models/exchange.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../chat_page.dart';
import '../../models/post.dart';
import '../../utils/map_util.dart';

class PostItem extends StatefulWidget {
  final Post post;
  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final ExchangeBloc exchangeBloc = ExchangeBloc();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          ListTile(
              title: Text(widget.post.providers[0].name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black,
                      )),
              subtitle:
                  Text(timeago.format(DateTime.parse(widget.post.createdAt)),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black45,
                          )),
              leading: Image.network(widget.post.providers[0].image.url,
                  width: 50, height: 50)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.type,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        ),
                        Text(
                          widget.post.type.name,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        )
                      ],
                    )),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.amount,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black45,
                            ),
                      ),
                      Text(
                        widget.post.amount.toString(),
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                      )
                    ],
                  ))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: SizedBox(
                    width: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.percentage,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        ),
                        Text(
                          "${widget.post.percentage}%",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                        )
                      ],
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.distance,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black45,
                            ),
                      ),
                      Text(
                        "${widget.post.distance}km",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                      )
                    ],
                  ))
            ],
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    MapUtils.openMap(widget.post.latLng.latitude,
                        widget.post.latLng.longitude);
                  },
                  child: Text(AppLocalizations.of(context)!.direction),
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
                            .createRoom(types.User(id: widget.post.adsUserId));

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
                                    types.User(id: existExchange[0].adsUserId),
                                    types.User(id: existExchange[0].exUserId)
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
            ),
          )
        ],
      ),
    );
  }
}
