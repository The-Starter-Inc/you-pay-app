import 'package:rxdart/rxdart.dart';
import '../models/app_version.dart';
import '../resources/app_version_repository.dart';

class AppVersionBloc {
  final repository = AppVersionRepository();
  final appVersionFetcher = PublishSubject<List<AppVersion>>();

  Stream<List<AppVersion>> get verifiedUsers => appVersionFetcher.stream;

  Future<List<AppVersion>> fetchAppVersion() async {
    List<AppVersion> appVersion = await repository.fetchAppVersion();
    return appVersion;
  }

  dispose() {
    appVersionFetcher.close();
  }
}

final bloc = AppVersionBloc();
