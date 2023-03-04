// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p2p_pay/src/blocs/post_bloc.dart';
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
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 0),
                child: SizedBox(
                    width: 100,
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
                          widget.post.type!.name,
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    color: Colors.black,
                                  ),
                        )
                      ],
                    )),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 0),
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
                                  color: Colors.black,
                                ),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.percentage,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black45,
                          ),
                    ),
                    Text(
                      "${widget.post.percentage}%",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Colors.black,
                          ),
                    )
                  ],
                ),
              )
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
            margin: const EdgeInsets.all(16),
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
