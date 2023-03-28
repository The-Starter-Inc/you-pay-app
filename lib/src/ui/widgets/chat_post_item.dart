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
      color: Colors.yellow.shade200,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Colors.black87,
                                          )),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 16))
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.yellow.shade200,
                                            ),
                                      ),
                                      const Icon(Icons.swap_horiz,
                                          color: Colors.black, size: 22)
                                    ],
                                  )),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(AppLocalizations.of(context)!.pay,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: Colors.black87,
                                        )),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 16))
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              color: Colors.black87,
                                              fontFamily: 'Pyidaungsu')),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: Colors.black,
                                                fontSize: 16)),
                                  ]),
                                ],
                              ),
                            if (widget.post.providers.length > 1)
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    children: [
                                      Text(
                                        "",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                      const Icon(Icons.swap_horiz,
                                          color: Colors.black, size: 22)
                                    ],
                                  )),
                            if (widget.post.providers.length > 1)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppLocalizations.of(context)!.pay,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: Colors.black87,
                                          )),
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
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 16))
                                    ],
                                  )
                                ],
                              )
                          ],
                        )),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                      widget.post.chargesType == 'percentage'
                          ? "${MyanNunber.convertNumber(widget.post.percentage.toString())} ${AppLocalizations.of(context)!.percentage}"
                          : widget.post.chargesType == 'fix_amount'
                              ? "${MyanNunber.convertMoneyNumber(widget.post.fees)} ${AppLocalizations.of(context)!.mmk} ${AppLocalizations.of(context)!.fixed_amount}"
                              : "${MyanNunber.convertMoneyNumber(widget.post.exchangeRate)} ${AppLocalizations.of(context)!.mmk} ${AppLocalizations.of(context)!.exchange_rate}",
                      textAlign: TextAlign.left,
                      style: const TextStyle(color: Colors.black54)))
            ],
          )),
    );
  }
}
