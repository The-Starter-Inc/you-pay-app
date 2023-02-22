import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/post.dart';
import '../blocs/post_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'widgets/post_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Post> posts = [];

  @override
  Widget build(BuildContext context) {
    //bloc.fetchPosts();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      // body: StreamBuilder(
      //   stream: bloc.posts,
      //   builder: (context, AsyncSnapshot<List<Post>> snapshot) {
      //     if (snapshot.hasData) {
      //       return buildList(snapshot);
      //     } else if (snapshot.hasError) {
      //       return Text(snapshot.error.toString());
      //     }
      //     return const Center(child: CircularProgressIndicator());
      //   },
      // ),
      body: buildList(posts),
    );
  }

//AsyncSnapshot<List<Post>> snapshot
  Widget buildList(List<Post> posts) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      clipBehavior: Clip.none,
      children: [...posts.map((post) => PostItem(post: post))],
    );
  }
}
