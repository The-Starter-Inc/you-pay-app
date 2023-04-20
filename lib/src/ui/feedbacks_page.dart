// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/feedback_bloc.dart';
import 'package:p2p_pay/src/blocs/verified_user_bloc.dart';
import 'package:p2p_pay/src/ui/widgets/feedback_item.dart';

import '../constants/app_constant.dart';
import '../models/feedback.dart' as types;
import '../models/user.dart';
import '../models/verified_user.dart';

class FeedbacksPage extends StatefulWidget {
  final User user;
  const FeedbacksPage({super.key, required this.user});
  static const String routeName = '/feedbacks';

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  bool isLoading = false;
  final FeedbackBloc feedbackBloc = FeedbackBloc();
  final VerifiedUserBloc verifiedUserBloc = VerifiedUserBloc();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Feedbacks Page");
    verifiedUserBloc.fetchVerifiedUsers(widget.user.phone!);
    getMyFeedback();
  }

  void getMyFeedback() {
    feedbackBloc.fetchFeedbacks(widget.user.id);
  }

  Future<void> sendFeedback(String response) async {
    try {
      isLoading = true;
      List<types.Feedback> feedbacks = await feedbackBloc.checkFeedbackExist(
          widget.user.id, AppConstant.currentUser!.id);
      if (feedbacks.isEmpty) {
        await feedbackBloc.createFeedback({
          'ads_user_id': widget.user.id,
          'ads_user': jsonEncode(widget.user.toJson()),
          'ex_user_id': AppConstant.currentUser!.id,
          'ex_user': jsonEncode(AppConstant.currentUser!.toJson()),
          'response': response
        });
        getMyFeedback();
        _showToast(context, "Your feedback has been submitted successfully.");
      } else {
        _showToast(context, "Your feedback already submitted successfully.");
      }
      isLoading = false;
    } catch (e) {
      isLoading = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.feedbacks,
                style: const TextStyle(color: Colors.black))),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Stack(
              children: [
                Column(
                  children: [
                    ListTile(
                        leading: Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade200,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Center(
                              child: Text(widget.user.name![0],
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.black)),
                            )),
                        title: Text(widget.user.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.black)),
                        subtitle: Text(widget.user.phone!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(color: Colors.black45)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StreamBuilder(
                                stream: verifiedUserBloc.verifiedUsers,
                                builder: (context,
                                    AsyncSnapshot<List<VerifiedUser>>
                                        snapshot) {
                                  if (snapshot.hasData &&
                                      snapshot.data!.isNotEmpty) {
                                    return Image.asset(
                                        "assets/images/trusted.png",
                                        width: 50);
                                  }
                                  return Container();
                                }),
                            const SizedBox(width: 10),
                            StreamBuilder(
                                stream: feedbackBloc.feedbacks,
                                builder: (context,
                                    AsyncSnapshot<List<types.Feedback>>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    var positive = snapshot.data!
                                        .where((x) => x.response == 'positive')
                                        .length;
                                    var negative = snapshot.data!
                                        .where((x) => x.response == 'negative')
                                        .length;
                                    return Column(
                                      children: [
                                        Text(
                                            AppLocalizations.of(context)!
                                                .feedbacks,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 12)),
                                        Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                  Icons.sentiment_satisfied_alt,
                                                  weight: 24,
                                                  color: Colors.green),
                                              const SizedBox(width: 8),
                                              Text("$positive",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color: Colors.black)),
                                              const SizedBox(width: 10),
                                              const Icon(
                                                  Icons
                                                      .sentiment_dissatisfied_outlined,
                                                  weight: 24,
                                                  color: Colors.red),
                                              const SizedBox(width: 8),
                                              Text("$negative",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color: Colors.black)),
                                            ])
                                      ],
                                    );
                                  }
                                  return Container();
                                }),
                          ],
                        )),
                    Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: const Divider(color: Colors.black45)),
                    StreamBuilder(
                      stream: feedbackBloc.feedbacks,
                      builder: (context,
                          AsyncSnapshot<List<types.Feedback>> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.only(top: 250),
                                child: Text(
                                    AppLocalizations.of(context)!.no_data,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: Colors.black45)));
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final feedback = snapshot.data![index];
                              return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: FeedbackItem(
                                    feedback: feedback,
                                  ));
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.black45));
                        }
                        return Container(
                            margin: const EdgeInsets.only(top: 200),
                            child: Image.asset("assets/images/loading.gif",
                                width: 100));
                      },
                    )
                  ],
                ),
                if (widget.user.id != AppConstant.currentUser!.id)
                  Positioned(
                      bottom: 15,
                      left: 0,
                      right: 0,
                      child: Center(
                          child: Column(
                        children: [
                          Text(AppLocalizations.of(context)!.give_feedback,
                              style: const TextStyle(color: Colors.black)),
                          const SizedBox(height: 10),
                          SizedBox(
                              width: 300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: Card(
                                        child: InkWell(
                                            onTap: () {
                                              sendFeedback('positive');
                                            },
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 24),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    const Icon(
                                                        Icons
                                                            .sentiment_satisfied_alt,
                                                        color: Colors.green,
                                                        size: 46),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .positive,
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.black54),
                                                    )
                                                  ],
                                                )))),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Card(
                                        child: InkWell(
                                      onTap: () {
                                        sendFeedback('negative');
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 24),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                  Icons
                                                      .sentiment_dissatisfied_outlined,
                                                  color: Colors.red,
                                                  size: 46),
                                              const SizedBox(height: 10),
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .negative,
                                                style: const TextStyle(
                                                    color: Colors.black54),
                                              )
                                            ],
                                          )),
                                    )),
                                  ),
                                ],
                              ))
                        ],
                      ))),
                if (isLoading)
                  Container(
                      margin: const EdgeInsets.only(top: 200),
                      child:
                          Image.asset("assets/images/loading.gif", width: 100))
              ],
            )));
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
