import 'package:rxdart/rxdart.dart';
import '../models/token.dart';
import '../resources/auth_repository.dart';

class AuthBloc {
  final repository = AuthRepository();
  final tokenFetcher = PublishSubject<Token>();

  Stream<Token> get token => tokenFetcher.stream;

  fetchToken(payload) async {
    Token token = await repository.fetchToken(payload);
    tokenFetcher.sink.add(token);
  }

  dispose() {
    tokenFetcher.close();
  }
}

final bloc = AuthBloc();
