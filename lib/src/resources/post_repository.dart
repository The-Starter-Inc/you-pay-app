import 'dart:async';

import '../models/post.dart';
import '../resources/post_provider.dart';

class PostRepository {
  final postApiProvider = PostApiProvider();

  Future<List<Post>> fetchPosts() => postApiProvider.fetchPosts();
}
