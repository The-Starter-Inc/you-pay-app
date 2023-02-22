import 'dart:async';
import 'ads_provider.dart';

import '../models/post.dart';

class ProviderRepository {
  final adsApiProvider = AdsApiProvider();

  Future<List<Provider>> fetchProviders() => adsApiProvider.fetchProviders();
}
