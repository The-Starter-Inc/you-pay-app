import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/feedback_bloc.dart';
import 'package:p2p_pay/src/ui/widgets/feedback_item.dart';

import '../constants/app_constant.dart';
import '../models/feedback.dart' as types;
import '../models/user.dart';
import '../theme/color_theme.dart';

class FeedbacksPage extends StatefulWidget {
  final User? user;
  const FeedbacksPage({super.key, this.user});
  static const String routeName = '/feedbacks';

  @override
  State<FeedbacksPage> createState() => _FeedbacksPageState();
}

class _FeedbacksPageState extends State<FeedbacksPage> {
  final FeedbackBloc feedbackBloc = FeedbackBloc();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Feedbacks Page");
    getMyFeedback();
  }

  void getMyFeedback() {
    feedbackBloc.fetchFeedbacks(AppConstant.firebaseUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.feedbacks)),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                ListTile(
                    leading: Container(
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: AppColor.primaryLight,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Center(
                          child: Text(AppConstant.currentUser!.name![0],
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.black)),
                        )),
                    title: Text(AppConstant.currentUser!.name!,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.black)),
                    subtitle: Text(AppConstant.currentUser!.phone!,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black45)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset("assets/images/trusted.png", width: 50),
                        StreamBuilder(
                            stream: feedbackBloc.feedbacks,
                            builder: (context,
                                AsyncSnapshot<List<types.Feedback>> snapshot) {
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
                                        AppLocalizations.of(context)!.feedbacks,
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
                  builder:
                      (context, AsyncSnapshot<List<types.Feedback>> snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.isEmpty) {
                        return Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 250),
                            child: Text(AppLocalizations.of(context)!.no_data,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.black45)));
                      }
                      return ListView.builder(
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
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              ],
            )));
  }
}
