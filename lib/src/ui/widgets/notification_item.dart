// ignore_for_file: depend_on_referenced_packages
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/models/general_noti.dart';
import 'package:p2p_pay/src/models/time_ago.dart';
import 'package:p2p_pay/src/ui/notification_detail_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class NotificationItem extends StatefulWidget {
  final GeneralNoti generalNoti;
  late bool? hasNotification;
  final Function? onClick;
  NotificationItem(
      {super.key,
      required this.generalNoti,
      this.hasNotification,
      this.onClick});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  final ExchangeBloc exchangeBloc = ExchangeBloc();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('en', TimeAgoMessages());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
            onTap: () async {
              try {
                final notifications =
                    await Localstore.instance.collection('notifications').get();
                if (notifications != null) {
                  notifications.forEach((key, value) {
                    RemoteMessage message = RemoteMessage.fromMap(value);
                    if ("${message.notification!.android!.tag}" ==
                        "topic_key_${widget.generalNoti.messageId}") {
                      Localstore.instance
                          .collection('notifications')
                          .doc(message.messageId)
                          .delete();
                    }
                    setState(() {
                      widget.hasNotification = false;
                    });
                  });
                }
                if (widget.generalNoti.linkToRedirect != null) {
                  Uri redirectUrl =
                      Uri.parse(widget.generalNoti.linkToRedirect!);
                  if (await canLaunchUrl(redirectUrl)) {
                    await launchUrl(redirectUrl);
                  } else {
                    throw 'Could not open the link.';
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  final navigator = Navigator.of(context);
                  await navigator.push(MaterialPageRoute(
                    builder: (context) =>
                        NotificationDetailPage(generalNoti: widget.generalNoti),
                  ));
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            },
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.yellow.shade200,
                borderRadius: const BorderRadius.all(Radius.circular(48)),
              ),
              child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: widget.generalNoti.type! == 'system'
                      ? const Center(child: Icon(Icons.construction))
                      : const Center(child: Icon(Icons.mail_outline))),
            ),
            title: Text(widget.generalNoti.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )),
            subtitle: Text(widget.generalNoti.subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                )),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeago.format(DateTime.parse(widget.generalNoti.createdAt)),
                ),
                const SizedBox(height: 16),
                widget.hasNotification!
                    ? const Icon(Icons.circle, size: 8, color: Colors.red)
                    : const Icon(Icons.circle, size: 8, color: Colors.grey)
              ],
            )),
        const Divider(
          color: Colors.black45,
        )
      ],
    );
  }
}
