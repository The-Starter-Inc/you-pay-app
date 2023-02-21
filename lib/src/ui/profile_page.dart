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
  List<Post> posts = [
    Post(
        id: 1,
        type: Type(id: 1, name: 'Cash Out'),
        provider: Provider(
            id: 1,
            name: 'KBZ Pay',
            icon: ImageUrl(url: 'assets/images/kbz-pay-circle.png'),
            marker: ImageUrl(url: "assets/images/kbz-marker.png"),
            image: ImageUrl(url: 'assets/images/kbz-pay.png')),
        amount: 1000000,
        percentage: 3,
        phone: '09767947154',
        latLng: const LatLng(16.79729673247046, 96.13215959983089),
        distance: 3),
    Post(
        id: 1,
        type: Type(id: 1, name: 'Cash Out'),
        provider: Provider(
            id: 1,
            name: 'Aya Pay',
            icon: ImageUrl(url: 'assets/images/aya-pay-circle.png'),
            marker: ImageUrl(url: "assets/images/aya-marker.png"),
            image: ImageUrl(url: 'assets/images/aya-pay.png')),
        amount: 1000000,
        percentage: 3,
        phone: '09767947154',
        latLng: const LatLng(16.793922748028915, 96.13219677131646),
        distance: 3),
    Post(
        id: 1,
        type: Type(id: 1, name: 'Cash Out'),
        provider: Provider(
            id: 1,
            name: 'Wave Pay',
            icon: ImageUrl(url: 'assets/images/wave-pay-circle.png'),
            marker: ImageUrl(url: "assets/images/wave-marker.png"),
            image: ImageUrl(url: 'assets/images/wave-pay.png')),
        amount: 1000000,
        percentage: 3,
        phone: '09767947154',
        latLng: const LatLng(16.800179334591768, 96.13606352271559),
        distance: 3),
    Post(
        id: 1,
        type: Type(id: 1, name: 'Cash Out'),
        provider: Provider(
            id: 1,
            name: 'CB Pay',
            icon: ImageUrl(url: 'assets/images/cb-pay-circle.png'),
            marker: ImageUrl(url: "assets/images/cb-marker.png"),
            image: ImageUrl(url: 'assets/images/cb-pay.png')),
        amount: 1000000,
        percentage: 3,
        phone: '09767947154',
        latLng: const LatLng(16.79962246841343, 96.13262424796903),
        distance: 3),
  ];

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
