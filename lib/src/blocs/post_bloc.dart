import 'package:rxdart/rxdart.dart';
import '../resources/post_repository.dart';
import '../models/post.dart';

class PostBloc {
  final repository = PostRepository();
  final postFetcher = PublishSubject<List<Post>>();

  Stream<List<Post>> get posts => postFetcher.stream;

  fetchPosts(String? keywords, String? search) async {
    List<Post> posts = await repository.fetchPosts(keywords, search);
    postFetcher.sink.add(posts);
  }

  Future<dynamic> createAdsPost(payload) async {
    Post post = await repository.createAdsPost(payload);
    return post;
  }

  Future<dynamic> deleteAdsPost(id) async {
    return await repository.deleteAdsPost(id);
  }

  dispose() {
    postFetcher.close();
  }
}

final bloc = PostBloc();
