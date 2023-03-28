import 'dart:async';
import 'general_noti_provider.dart';

import '../models/general_noti.dart';

class GeneralNotiRepository {
  final sponsorApiProvider = GeneralNotiApiProvider();

  Future<List<GeneralNoti>> fetchSGeneralNotifications() =>
      sponsorApiProvider.fetchSGeneralNotifications();
}
