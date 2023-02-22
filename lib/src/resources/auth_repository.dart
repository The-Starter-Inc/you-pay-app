import 'dart:async';
import '../models/token.dart';
import 'auth_provider.dart';

class AuthRepository {
  final authApiProvider = AuthApiProvider();

  Future<Token> fetchToken(payload) => authApiProvider.fetchToken(payload);
}
