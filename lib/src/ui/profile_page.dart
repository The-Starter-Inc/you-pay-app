import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/verified_user_bloc.dart';
import 'package:p2p_pay/src/ui/feedbacks_page.dart';
import 'package:p2p_pay/src/ui/my_post_page.dart';
import '../blocs/feedback_bloc.dart';
import '../models/verified_user.dart';
import '../theme/color_theme.dart';
import '../constants/app_constant.dart';
import '../blocs/post_bloc.dart';
import '../models/feedback.dart' as types;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PostBloc postBloc = PostBloc();
  final FeedbackBloc feedbackBloc = FeedbackBloc();
  final VerifiedUserBloc verifiedUserBloc = VerifiedUserBloc();
  String language = "mm";

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "Profile Page");
    AppConstant.postCreated.subscribe((data) => getMyPosts());
    feedbackBloc.fetchFeedbacks(AppConstant.firebaseUser!.uid);
    verifiedUserBloc.fetchVerifiedUsers(AppConstant.currentUser!.phone!);
    getMyPosts();
  }

  void getMyPosts() {
    postBloc.fetchPosts(
        null, "ads_user_id:equal:${AppConstant.firebaseUser!.uid}");
  }

  void showLanguateDialog() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.eng,
                  style: const TextStyle(color: Colors.black54)),
              value: "en",
              groupValue: language,
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
              },
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.mm,
                  style: const TextStyle(color: Colors.black54)),
              value: "my",
              groupValue: language,
              onChanged: (value) {
                setState(() {
                  language = value!;
                });
              },
            )
          ],
        ),
        title: Text(
          AppLocalizations.of(context)!.language,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.black,
                fontFamily: 'Pyidaungsu',
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.profile,
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: AppColor.primaryColor),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            ListTile(
                leading: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Center(
                      child: Text(AppConstant.currentUser!.name![0],
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Colors.black,
                                  fontFamily: 'Pyidaungsu')),
                    )),
                title: Text(AppConstant.currentUser!.name!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.black, fontFamily: 'Pyidaungsu')),
                subtitle: Text(AppConstant.currentUser!.phone!,
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
                            AsyncSnapshot<List<VerifiedUser>> snapshot) {
                          if (snapshot.hasData) {
                            return Image.asset("assets/images/trusted.png",
                                width: 50);
                          }
                          return Container();
                        }),
                    const SizedBox(width: 10),
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
                                Text(AppLocalizations.of(context)!.feedbacks,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .copyWith(
                                            color: Colors.black, fontSize: 12)),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.sentiment_satisfied_alt,
                                      weight: 24, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text("$positive",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.black)),
                                  const SizedBox(width: 10),
                                  const Icon(
                                      Icons.sentiment_dissatisfied_outlined,
                                      weight: 24,
                                      color: Colors.red),
                                  const SizedBox(width: 8),
                                  Text("$negative",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(color: Colors.black)),
                                ])
                              ],
                            );
                          }
                          return Container();
                        }),
                  ],
                )),
            Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: const Divider(color: Colors.black45)),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FeedbacksPage(user: AppConstant.currentUser!)),
                );
              },
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(48)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Center(child: Icon(Icons.feedback_outlined)),
                ),
              ),
              title: Text(AppLocalizations.of(context)!.feedbacks,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black54,
                      fontSize: 16,
                      fontFamily: 'Pyidaungsu')),
            ),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyPostPage()),
                );
              },
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(48)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Center(child: Icon(Icons.post_add_outlined)),
                ),
              ),
              title: Text(AppLocalizations.of(context)!.my_posts,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.black54,
                      fontSize: 16,
                      fontFamily: 'Pyidaungsu')),
            ),
            // const SizedBox(height: 10),
            // ListTile(
            //   onTap: () {
            //     showLanguateDialog();
            //   },
            //   leading: Container(
            //     width: 48,
            //     height: 48,
            //     decoration: BoxDecoration(
            //       color: Colors.yellow.shade200,
            //       borderRadius: const BorderRadius.all(Radius.circular(48)),
            //     ),
            //     child: const Padding(
            //       padding: EdgeInsets.all(4),
            //       child: Center(child: Icon(Icons.language)),
            //     ),
            //   ),
            //   title: Text(AppLocalizations.of(context)!.language,
            //       style: Theme.of(context).textTheme.titleLarge!.copyWith(
            //           color: Colors.black54,
            //           fontSize: 16,
            //           fontFamily: 'Pyidaungsu')),
            // )
          ],
        ),
      ),
    );
  }
}
