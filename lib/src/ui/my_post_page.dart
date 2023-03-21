import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../blocs/post_bloc.dart';
import '../constants/app_constant.dart';
import '../models/post.dart';
import 'widgets/my_post_item.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({super.key});
  static const String routeName = '/myPost';

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  final PostBloc postBloc = PostBloc();

  @override
  void initState() {
    super.initState();
    FirebaseAnalytics.instance.setCurrentScreen(screenName: "My Post Page");
    AppConstant.postCreated.subscribe((data) => getMyPosts());
    getMyPosts();
  }

  void getMyPosts() {
    postBloc.fetchPosts(
        null, "ads_user_id:equal:${AppConstant.firebaseUser!.uid}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.my_posts)),
        body: StreamBuilder(
          stream: postBloc.posts,
          builder: (context, AsyncSnapshot<List<Post>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.no_data,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Colors.black45)));
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: MyPostItem(
                          post: post,
                          onDeleted: () {
                            getMyPosts();
                          },
                          onCreated: () {
                            getMyPosts();
                          }));
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
        ));
  }
}
