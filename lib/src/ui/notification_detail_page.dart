import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:p2p_pay/src/models/general_noti.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/color_theme.dart';

class NotificationDetailPage extends StatefulWidget {
  const NotificationDetailPage({required this.generalNoti, super.key});
  static const String routeName = '/generalNotiDetail.dart';

  final GeneralNoti generalNoti;

  @override
  State<NotificationDetailPage> createState() => _NotificationDetailPageState();
}

class _NotificationDetailPageState extends State<NotificationDetailPage> {
  final DateFormat formatter = DateFormat('dd MMM, yyyy h:m a');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.notifications,
                style: const TextStyle(color: Colors.black)),
            backgroundColor: AppColor.primaryColor),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.generalNoti.title!,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Colors.black87,
                                  fontFamily: 'Pyidaungsu')),
                      Text(
                          formatter.format(
                              DateTime.parse(widget.generalNoti.createdAt)),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: Colors.black87,
                                  fontFamily: 'Pyidaungsu')),
                      if (widget.generalNoti.image!.url != "")
                        CachedNetworkImage(
                            imageUrl: widget.generalNoti.image!.url),
                      const SizedBox(height: 24),
                      if (widget.generalNoti.descriptions != null)
                        Text(widget.generalNoti.descriptions!,
                            style: const TextStyle(color: Colors.black54))
                      else
                        Text(widget.generalNoti.subtitle!,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: Colors.black87,
                                    fontFamily: 'Pyidaungsu')),
                    ]),
              ),
            )));
  }
}
