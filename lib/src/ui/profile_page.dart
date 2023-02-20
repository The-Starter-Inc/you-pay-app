import 'package:flutter/material.dart';
import '../models/post.dart';
import '../blocs/post_bloc.dart';
import 'dashboard_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    //bloc.fetchPosts();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "ProfilePage",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          },
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
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildList(AsyncSnapshot<List<Post>> snapshot) {
    return GridView.builder(
        itemCount: snapshot.data!.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            snapshot.data![index].provider.image.url,
            fit: BoxFit.cover,
          );
        });
  }
}
