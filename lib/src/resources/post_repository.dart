import 'dart:async';

import '../models/post.dart';
import '../resources/post_provider.dart';

class PostRepository {
  final postApiProvider = PostApiProvider();

  Future<List<Post>> fetchPosts(String? keywords, String? search) =>
      postApiProvider.fetchPosts(keywords, search);

  Future<Post> createAdsPost(payload) => postApiProvider.createAdsPost(payload);
  Future<dynamic> deleteAdsPost(id) => postApiProvider.deleteAdsPost(id);
}
