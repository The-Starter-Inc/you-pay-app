import 'package:rxdart/rxdart.dart';
import '../models/general_noti.dart';
import '../resources/general_noti_repository.dart';

class GeneralNotiBloc {
  final repository = GeneralNotiRepository();
  final generalNotiFetcher = PublishSubject<List<GeneralNoti>>();

  Stream<List<GeneralNoti>> get generalNotis => generalNotiFetcher.stream;

  fetchSGeneralNotifications() async {
    List<GeneralNoti> generalNotis =
        await repository.fetchSGeneralNotifications();
    generalNotiFetcher.sink.add(generalNotis);
  }

  dispose() {
    generalNotiFetcher.close();
  }
}

final bloc = GeneralNotiBloc();
