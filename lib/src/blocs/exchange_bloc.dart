import 'package:rxdart/rxdart.dart';
import '../models/exchange.dart';
import '../resources/exchange_repository.dart';

class ExchangeBloc {
  final repository = ExchangeRepository();
  final exchangeFetcher = PublishSubject<List<Exchange>>();
  final exchangeCreater = PublishSubject<Exchange>();

  Stream<Exchange> get creater => exchangeCreater.stream;
  Stream<List<Exchange>> get exchange => exchangeFetcher.stream;

  Future<Exchange> createExchange(payload) async {
    Exchange exchange = await repository.createExchange(payload);
    return exchange;
  }

  fetchExchages() async {
    List<Exchange> exchanges = await repository.fetchExchanges();
    exchangeFetcher.sink.add(exchanges);
  }

  dispose() {
    exchangeFetcher.close();
    exchangeCreater.close();
  }
}

final bloc = ExchangeBloc();
