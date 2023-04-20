import 'dart:async';

import './../models/verified_user.dart';
import 'verified_user_provider.dart';

class VerifiedUserRepository {
  final verifiedUserApiProvider = VerifiedUserApiProvider();

  Future<List<VerifiedUser>> fetchVerifiedUser(String phone) =>
      verifiedUserApiProvider.fetchVerifiedUser(phone);
}
