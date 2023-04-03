import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:p2p_pay/src/blocs/verified_user_bloc.dart';
import 'package:p2p_pay/src/ui/feedbacks_page.dart';
import 'package:p2p_pay/src/ui/my_post_page.dart';
import 'package:provider/provider.dart';
import '../blocs/feedback_bloc.dart';
import '../models/verified_user.dart';
import '../provider/theme_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeChanger>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.profile,
          )),
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
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    )),
                subtitle: Text(AppConstant.currentUser!.phone!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    )),
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
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                    )),
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  const Icon(Icons.sentiment_satisfied_alt,
                                      weight: 24, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text("$positive",
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold
                                      )),
                                  const SizedBox(width: 10),
                                  const Icon(
                                      Icons.sentiment_dissatisfied_outlined,
                                      weight: 24,
                                      color: Colors.red),
                                  const SizedBox(width: 8),
                                  Text("$negative",
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold
                                      )),
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
                child: const Divider(color: Colors.grey)),
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
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  )),
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
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  )),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.yellow.shade200,
                  borderRadius: const BorderRadius.all(Radius.circular(48)),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Center(child: Icon(Icons.dark_mode)),
                ),
              ),
              trailing: CupertinoSwitch(
                value: theme.currentTheme=="dark",
                onChanged: (bool val) {
                  theme.setTheme(theme.currentTheme == "dark"?"light":"dark");
                },
              ),
              title: Text(AppLocalizations.of(context)!.dark_mode,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  )),
            )
          ],
        ),
      ),
    );
  }
}
