import 'dart:async';

import './../models/exchange.dart';
import '../resources/exchange_provider.dart';

class ExchangeRepository {
  final exchangeApiProvider = ExchangeApiProvider();

  Future<List<Exchange>> fetchExchanges() =>
      exchangeApiProvider.fetchExchanges();

  Future<Exchange> createExchange(payload) =>
      exchangeApiProvider.createExhange(payload);
}
