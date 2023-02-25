// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/post_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/post.dart';

class MyPostItem extends StatefulWidget {
  final Post post;
  final Function? onDeleted;
  const MyPostItem({super.key, required this.post, this.onDeleted});

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
                              await postBloc
                                  .deleteAdsPost(widget.post.id.toString());
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
                  child: Text(AppLocalizations.of(context)!.delete),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        isLoading ? Colors.black45 : Colors.lightBlue),
                    foregroundColor: MaterialStateProperty.all<Color>(
                        isLoading ? Colors.black45 : Colors.lightBlue),
                  ),
                  onPressed: () async {},
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
}
