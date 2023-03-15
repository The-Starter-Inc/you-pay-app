import 'package:rxdart/rxdart.dart';
import '../resources/post_repository.dart';
import '../models/post.dart';

class PostBloc {
  final repository = PostRepository();
  final postFetcher = PublishSubject<List<Post>>();
  final getPostById = PublishSubject<Post>();

  Stream<List<Post>> get posts => postFetcher.stream;
  Stream<Post> get post => getPostById.stream;

  fetchPosts(String? keywords, String? search) async {
    List<Post> posts = await repository.fetchPosts(keywords, search);
    postFetcher.sink.add(posts);
  }

  fetchPostById(id) async {
    Post post = await repository.getAdsPost(id);
    getPostById.sink.add(post);
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
