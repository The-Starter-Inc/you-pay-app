import 'package:rxdart/rxdart.dart';
import '../models/sponsor.dart';
import '../resources/sponsor_repository.dart';

class SponsorBloc {
  final repository = SponsorRepository();
  final sponsorFetcher = PublishSubject<List<Sponsor>>();

  Stream<List<Sponsor>> get sponsors => sponsorFetcher.stream;

  fetchSponsors(type) async {
    List<Sponsor> sponsors = await repository.fetchSponsors(type);
    sponsorFetcher.sink.add(sponsors);
  }

  dispose() {
    sponsorFetcher.close();
  }
}

final bloc = SponsorBloc();
