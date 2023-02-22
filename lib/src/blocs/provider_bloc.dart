import 'package:rxdart/rxdart.dart';
import '../models/post.dart';
import '../resources/provider_repository.dart';

class ProviderBloc {
  final repository = ProviderRepository();
  final providerFetcher = PublishSubject<List<Provider>>();

  Stream<List<Provider>> get providers => providerFetcher.stream;

  fetchProviders() async {
    List<Provider> providers = await repository.fetchProviders();
    providerFetcher.sink.add(providers);
  }

  dispose() {
    providerFetcher.close();
  }
}

final bloc = ProviderBloc();
