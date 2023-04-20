import 'package:rxdart/rxdart.dart';
import '../models/feedback.dart';
import '../resources/feedback_repository.dart';

class FeedbackBloc {
  final repository = FeedbackRepository();
  final exchangeFetcher = PublishSubject<List<Feedback>>();

  Stream<List<Feedback>> get feedbacks => exchangeFetcher.stream;

  Future<Feedback> createFeedback(payload) async {
    Feedback exchange = await repository.createFeedback(payload);
    return exchange;
  }

  Future<List<Feedback>> checkFeedbackExist(
      String adsPostId, String exUserId) async {
    List<Feedback> exchange =
        await repository.checkFeedbackExist(adsPostId, exUserId);
    return exchange;
  }

  fetchFeedbacks(String adsUserId) async {
    List<Feedback> exchanges = await repository.fetchFeedbacks(adsUserId);
    exchangeFetcher.sink.add(exchanges);
  }

  dispose() {
    exchangeFetcher.close();
  }
}

final bloc = FeedbackBloc();
