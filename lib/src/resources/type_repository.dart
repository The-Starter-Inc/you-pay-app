import 'dart:async';
import 'type_provider.dart';

import '../models/post.dart';

class TypeRepository {
  final typeApiProvider = TypeApiProvider();

  Future<List<Type>> fetchTypes() => typeApiProvider.fetchTypes();
}
