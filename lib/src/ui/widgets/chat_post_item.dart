import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/exchange_bloc.dart';
import 'package:p2p_pay/src/constants/app_constant.dart';
import '../../blocs/post_bloc.dart';
import '../../utils/myan_number.dart';
import '../../models/post.dart';

class ChatPostItem extends StatefulWidget {
  final Post post;
  const ChatPostItem({super.key, required this.post});

  @override
  State<ChatPostItem> createState() => _ChatPostItemState();
}

class _ChatPostItemState extends State<ChatPostItem> {
  final PostBloc postBloc = PostBloc();
  final ExchangeBloc exchangeBloc = ExchangeBloc();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.yellow.shade200,
      child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Column(
            children: [
              ListTile(
                title: widget.post.adsUserId != AppConstant.firebaseUser!.uid
                    ? Row(
                        children: [
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
                                      child: Text("ယူ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12))),
                                ),
                                Text(widget.post.providers[1].name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Colors.black, fontSize: 16))
                              ],
                            ),
                          if (widget.post.providers.length > 1)
                            const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(Icons.swap_horiz,
                                    color: Colors.black, size: 22)),
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
                                            color: Colors.white,
                                            fontSize: 12))),
                              ),
                              Text(widget.post.providers[0].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                          color: Colors.black, fontSize: 16))
                            ],
                          )
                        ],
                      )
                    : Row(
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
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12))),
                            ),
                            Text(widget.post.providers[0].name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: Colors.black, fontSize: 16)),
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
                                              color: Colors.white,
                                              fontSize: 12))),
                                ),
                                Text(widget.post.providers[1].name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: Colors.black, fontSize: 16))
                              ],
                            )
                        ],
                      ),
                subtitle: Text(
                    widget.post.chargesType == 'percentage'
                        ? "${MyanNunber.convertNumber(widget.post.percentage.toString())} ${AppLocalizations.of(context)!.percentage}"
                        : "${MyanNunber.convertMoneyNumber(widget.post.fees)} ${AppLocalizations.of(context)!.mmk} ${AppLocalizations.of(context)!.fixed_amount}",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Colors.black87,
                        )),
                // leading: Image(
                //     image: CachedNetworkImageProvider(
                //         widget.post.providers[0].image.url),
                //     width: 50,
                //     height: 50),
              )
            ],
          )),
    );
  }
}
