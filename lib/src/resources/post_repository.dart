import 'dart:async';

import '../models/post.dart';
import '../resources/post_provider.dart';

class PostRepository {
  final postApiProvider = PostApiProvider();

  Future<List<Post>> fetchPosts(String? keywords, String? search) =>
      postApiProvider.fetchPosts(keywords, search);
  Future<List<Post>> fetchMyPosts(String? search) =>
      postApiProvider.fetchMyPosts(search);

  Future<Post> getAdsPost(id) => postApiProvider.getAdsPost(id);
  Future<Post> createAdsPost(payload) => postApiProvider.createAdsPost(payload);
  Future<Post> updateAdsPost(id, payload) =>
      postApiProvider.updateAdsPost(id, payload);
  Future<dynamic> deleteAdsPost(id) => postApiProvider.deleteAdsPost(id);
}
