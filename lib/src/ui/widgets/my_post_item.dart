// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2p_pay/src/blocs/post_bloc.dart';
import 'package:p2p_pay/src/utils/myan_number.dart';
import 'package:p2p_pay/src/theme/color_theme.dart';
import '../../constants/app_constant.dart';
import '../../models/post.dart';
import '../../theme/text_size.dart';
import '../entry/create_post_page.dart';

class MyPostItem extends StatefulWidget {
  final Post post;
  final Function? onDeleted;
  final Function? onCreated;
  const MyPostItem(
      {super.key, required this.post, this.onDeleted, this.onCreated});

  @override
  State<MyPostItem> createState() => _MyPostItemState();
}

class _MyPostItemState extends State<MyPostItem> {
  final PostBloc postBloc = PostBloc();
  bool isLoading = false;

  void updatePost() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    widget.post.status =
        widget.post.status != null && widget.post.status! ? false : true;
    await postBloc.updateAdsPost(
        widget.post.id.toString(), widget.post.toJson());
    Fluttertoast.showToast(
        msg: "Your post have been updated successfully.!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        textColor: Colors.white,
        fontSize: 16.0);
    setState(() {
      isLoading = false;
    });
    widget.onDeleted!();
  }

  void deletePost() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: TextSize.size16)),
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
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextSize.size16,
            ),
          ),
        ],
        content: Text(AppLocalizations.of(context)!.delete_confirm_msg,
            style: TextSize.size14),
        title: Text(
          AppLocalizations.of(context)!.confirm,
          style: TextSize.size16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 0),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                  margin:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: widget.post.adsUserId != AppConstant.firebaseUser!.uid
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.post.providers.length > 1)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.you,
                                      textAlign: TextAlign.start,
                                      style: TextSize.size12),
                                  Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 16,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            color: Color(int.parse(widget
                                                    .post.providers[1].color ??
                                                "0xFFCCCCCC"))),
                                      ),
                                      Text(widget.post.providers[1].name,
                                          style: TextSize.size16)
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
                                        AppLocalizations.of(context)!.you,
                                        style: TextSize.size12,
                                      ),
                                      const Icon(Icons.swap_horiz, size: 22)
                                    ],
                                  )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.pay,
                                    style: TextSize.size12),
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
                                        style: TextSize.size16)
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      : Row(
                          children: [
                            if (widget.post.providers.length > 1)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.you,
                                      textAlign: TextAlign.start,
                                      style: TextSize.size12),
                                  Row(children: [
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
                                        style: TextSize.size16),
                                  ]),
                                ],
                              ),
                            if (widget.post.providers.length > 1)
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: const [
                                      Icon(Icons.swap_horiz, size: 22)
                                    ],
                                  )),
                            if (widget.post.providers.length > 1)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.pay,
                                      style: TextSize.size12),
                                  Row(
                                    children: [
                                      Container(
                                        width: 3,
                                        height: 16,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: BoxDecoration(
                                            color: Color(int.parse(widget
                                                    .post.providers[1].color ??
                                                "0xFFCCCCCC"))),
                                      ),
                                      Text(widget.post.providers[1].name,
                                          style: TextSize.size16)
                                    ],
                                  )
                                ],
                              )
                          ],
                        )),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 130,
                      margin: const EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.amount,
                            style: TextSize.size14,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                  "${MyanNunber.convertMoneyNumber(widget.post.amount)}",
                                  style: TextSize.size14))
                        ],
                      )),
                  Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.chargesType == 'percentage'
                                ? AppLocalizations.of(context)!.percentage
                                : widget.post.chargesType == 'fix_amount'
                                    ? AppLocalizations.of(context)!.fixed_amount
                                    : AppLocalizations.of(context)!
                                        .exchange_rate,
                            style: TextSize.size14,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Text(
                                  widget.post.chargesType == 'percentage'
                                      ? "${MyanNunber.convertNumber(widget.post.percentage.toString())}%"
                                      : widget.post.chargesType == 'fix_amount'
                                          ? "${MyanNunber.convertMoneyNumber(widget.post.fees)} ${AppLocalizations.of(context)!.mmk}"
                                          : "${MyanNunber.convertMoneyNumber(widget.post.exchangeRate)} ${AppLocalizations.of(context)!.mmk}",
                                  style: TextSize.size14))
                        ],
                      )),
                ],
              )
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
                  ))),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 1,
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      leading: const Icon(Icons.edit, color: Colors.orange),
                      title: Text(
                        AppLocalizations.of(context)!.edit,
                        style: TextSize.size14,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      leading: const Icon(Icons.remove_red_eye_outlined,
                          color: Colors.blue),
                      title: Text(
                        widget.post.status != null && widget.post.status!
                            ? AppLocalizations.of(context)!.hide_post
                            : AppLocalizations.of(context)!.show_post,
                        style: TextSize.size14,
                      ),
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    padding: const EdgeInsets.all(0),
                    child: ListTile(
                      leading: const Icon(Icons.delete_forever_rounded,
                          color: Colors.red),
                      title: Text(
                        AppLocalizations.of(context)!.delete,
                        style: TextSize.size14,
                      ),
                    ),
                  )
                ];
              },
              onSelected: (value) async {
                // deleteExchange();
                if (value == 1) {
                  String updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreatePostPage(post: widget.post)),
                  );
                  if (updated == "_createdPost" && widget.onCreated != null) {
                    widget.onCreated!();
                  }
                }
                if (value == 2) {
                  updatePost();
                }
                if (value == 3) {
                  deletePost();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message, style: TextSize.size14),
        action: SnackBarAction(
            label: 'Okay', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
