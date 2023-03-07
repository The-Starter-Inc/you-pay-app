// ignore_for_file: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/models/exchange.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../chat_page.dart';

class NotificationItem extends StatefulWidget {
  final Exchange exchange;
  const NotificationItem({super.key, required this.exchange});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  final ExchangeBloc exchangeBloc = ExchangeBloc();
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: GestureDetector(
            onTap: () async {
              try {
                final navigator = Navigator.of(context);
                await navigator.push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
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
                    title: Text(widget.exchange.post!.providers[0].name,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Colors.black,
                            )),
                    subtitle: Row(
                      children: [
                        const Icon(
                          Icons.timelapse_outlined,
                          size: 18,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 10),
                        Text(
                            timeago.format(
                                DateTime.parse(widget.exchange.createdAt)),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black45,
                                ))
                      ],
                    ),
                    leading: Image(
                        image: CachedNetworkImageProvider(
                            widget.exchange.post!.providers[0].image.url),
                        width: 50,
                        height: 50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: SizedBox(
                          width: 130,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.type,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.black45,
                                    ),
                              ),
                              Text(
                                widget.exchange.post!.type!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      color: Colors.black45,
                                    ),
                              )
                            ],
                          )),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16),
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
                            Text(
                              widget.exchange.amount.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.black45,
                                  ),
                            )
                          ],
                        ))
                  ],
                )
              ],
            )));
  }
}
