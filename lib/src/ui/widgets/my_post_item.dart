// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2p_pay/src/blocs/post_bloc.dart';
import 'package:p2p_pay/src/utils/myan_number.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:p2p_pay/src/theme/color_theme.dart';
import '../../models/post.dart';
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
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          ListTile(
            title: Row(
              children: [
                Row(children: [
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    height: 32,
                    width: 32,
                    child: const Center(
                        child: Text("ယူ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 12))),
                  ),
                  Text(widget.post.providers[0].name,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.black, fontSize: 16)),
                ]),
                if (widget.post.providers.length > 1)
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(Icons.swap_horiz,
                          color: Colors.black, size: 22)),
                if (widget.post.providers.length > 1)
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(32),
                        ),
                        height: 32,
                        width: 32,
                        child: const Center(
                            child: Text("ပေး",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12))),
                      ),
                      Text(widget.post.providers[1].name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.black, fontSize: 16))
                    ],
                  )
              ],
            ),
            // subtitle:
            //     Text(timeago.format(DateTime.parse(widget.post.createdAt)),
            //         style: Theme.of(context).textTheme.titleMedium!.copyWith(
            //               color: Colors.black45,
            //             )),
            // leading: Image(
            //     image: CachedNetworkImageProvider(
            //         widget.post.providers[0].image.url),
            //     width: 50,
            //     height: 50)
          ),
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
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black45,
                            ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                              "${MyanNunber.convertMoneyNumber(widget.post.amount)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.black,
                                  )))
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
                            : AppLocalizations.of(context)!.fixed_amount,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Colors.black45,
                            ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Text(
                              widget.post.chargesType == 'percentage'
                                  ? "${MyanNunber.convertNumber(widget.post.percentage.toString())}%"
                                  : "${MyanNunber.convertMoneyNumber(widget.post.fees)} ${AppLocalizations.of(context)!.mmk}",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: Colors.black,
                                  )))
                    ],
                  )),
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Padding(
          //       padding: const EdgeInsets.only(left: 16, right: 16),
          //       child: SizedBox(
          //           width: 130,
          //           child: Column(
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Text(
          //                 AppLocalizations.of(context)!.percentage,
          //                 style:
          //                     Theme.of(context).textTheme.bodyMedium!.copyWith(
          //                           color: Colors.black45,
          //                         ),
          //               ),
          //               Text(
          //                 "${widget.post.percentage}%",
          //                 style:
          //                     Theme.of(context).textTheme.titleMedium!.copyWith(
          //                           color: Colors.black45,
          //                         ),
          //               )
          //             ],
          //           )),
          //     ),
          //     Padding(
          //         padding: const EdgeInsets.only(left: 16, right: 16),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               AppLocalizations.of(context)!.distance,
          //               style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          //                     color: Colors.black45,
          //                   ),
          //             ),
          //             Text(
          //               "${widget.post.distance}km",
          //               style:
          //                   Theme.of(context).textTheme.titleMedium!.copyWith(
          //                         color: Colors.black45,
          //                       ),
          //             )
          //           ],
          //         ))
          //   ],
          // ),
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
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
                              child: Text(AppLocalizations.of(context)!.cancel,
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
                              String deletedPost = await postBloc
                                  .deleteAdsPost(widget.post.id.toString());
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
                        content: Text(
                            AppLocalizations.of(context)!.delete_confirm_msg,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  color: Colors.black,
                                )),
                        title: Text(
                          AppLocalizations.of(context)!.confirm,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        ),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.delete,
                      style: const TextStyle(color: AppColor.secondaryColor)),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        isLoading ? Colors.black45 : AppColor.secondaryColor),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        isLoading ? Colors.black45 : AppColor.secondaryColor),
                  ),
                  onPressed: () async {
                    String updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CreatePostPage(post: widget.post)),
                    );
                    if (updated == "_createdPost" && widget.onCreated != null) {
                      widget.onCreated!();
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.edit,
                      style: const TextStyle(color: Colors.white)),
                )
              ],
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
        content: Text(message),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
