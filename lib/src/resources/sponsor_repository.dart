import 'dart:async';
import 'sponsor_provider.dart';

import '../models/sponsor.dart';

class SponsorRepository {
  final sponsorApiProvider = SponsorApiProvider();

  Future<List<Sponsor>> fetchSponsors(type) =>
      sponsorApiProvider.fetchSponsors(type);
}
