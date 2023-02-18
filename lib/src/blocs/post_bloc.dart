import 'package:rxdart/rxdart.dart';
import '../resources/post_repository.dart';
import '../models/post.dart';

class PostBloc {
  final repository = PostRepository();
  final postFetcher = PublishSubject<List<Post>>();

  Stream<List<Post>> get posts => postFetcher.stream;

  fetchPosts() async {
    List<Post> posts = await repository.fetchPosts();
    postFetcher.sink.add(posts);
  }

  dispose() {
    postFetcher.close();
  }
}

final bloc = PostBloc();
