import 'dart:async';

import './../models/exchange.dart';
import '../resources/exchange_provider.dart';

class ExchangeRepository {
  final exchangeApiProvider = ExchangeApiProvider();

  Future<List<Exchange>> fetchExchanges(String firebaseUserId) =>
      exchangeApiProvider.fetchExchanges(firebaseUserId);

  Future<List<Exchange>> fetchExchangesByQuery(String query) =>
      exchangeApiProvider.fetchExchangesByQuery(query);

  Future<List<Exchange>> checkExchangeExist(
          String adsPostid, String exUserId) =>
      exchangeApiProvider.checkExchangeExist(adsPostid, exUserId);

  Future<Exchange> createExchange(payload) =>
      exchangeApiProvider.createExhange(payload);

  Future<dynamic> deleteExchange(id) => exchangeApiProvider.deleteExchange(id);
}
