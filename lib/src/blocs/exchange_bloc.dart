import 'package:rxdart/rxdart.dart';
import '../models/exchange.dart';
import '../resources/exchange_repository.dart';

class ExchangeBloc {
  final repository = ExchangeRepository();
  final exchangeFetcher = PublishSubject<List<Exchange>>();

  Stream<List<Exchange>> get exchange => exchangeFetcher.stream;

  Future<Exchange> createExchange(payload) async {
    Exchange exchange = await repository.createExchange(payload);
    return exchange;
  }

  Future<List<Exchange>> checkExchangeExist(
      String adsPostId, String exUserId) async {
    List<Exchange> exchange =
        await repository.checkExchangeExist(adsPostId, exUserId);
    return exchange;
  }

  fetchExchages(String firebaseUserId) async {
    List<Exchange> exchanges = await repository.fetchExchanges(firebaseUserId);
    exchangeFetcher.sink.add(exchanges);
  }

  dispose() {
    exchangeFetcher.close();
  }
}

final bloc = ExchangeBloc();
