import 'package:rxdart/rxdart.dart';
import '../models/post.dart';
import '../resources/type_repository.dart';

class TypeBloc {
  final repository = TypeRepository();
  final typeFetcher = PublishSubject<List<Type>>();

  Stream<List<Type>> get types => typeFetcher.stream;

  fetchPosts() async {
    List<Type> types = await repository.fetchTypes();
    typeFetcher.sink.add(types);
  }

  dispose() {
    typeFetcher.close();
  }
}

final bloc = TypeBloc();
