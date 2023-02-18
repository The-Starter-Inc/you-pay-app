import 'package:flutter/material.dart';

class CreatePostPage extends StatefulWidget {
  static const String routeName = '/post';

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  // final _postBloc = PostBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post'),
      ),
      body: const Center(
        child: Text("Post Create"),
      ),
    );
  }
}
