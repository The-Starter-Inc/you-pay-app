import 'package:rxdart/rxdart.dart';
import '../models/verified_user.dart';
import '../resources/verified_user_repository.dart';

class VerifiedUserBloc {
  final repository = VerifiedUserRepository();
  final verifiedUserFetcher = PublishSubject<List<VerifiedUser>>();

  Stream<List<VerifiedUser>> get verifiedUsers => verifiedUserFetcher.stream;

  fetchVerifiedUsers(String phone) async {
    List<VerifiedUser> verifiedUsers =
        await repository.fetchVerifiedUser(phone);
    verifiedUserFetcher.sink.add(verifiedUsers);
  }

  dispose() {
    verifiedUserFetcher.close();
  }
}

final bloc = VerifiedUserBloc();
