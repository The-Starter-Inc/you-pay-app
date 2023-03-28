import 'dart:async';

import './../models/app_version.dart';
import 'app_version_provider.dart';

class AppVersionRepository {
  final appVersionApiProvider = AppVersionApiProvider();

  Future<List<AppVersion>> fetchAppVersion() =>
      appVersionApiProvider.fetchAppVersion();
}
