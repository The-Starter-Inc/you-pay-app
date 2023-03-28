import 'dart:async';

import './../models/feedback.dart';
import '../resources/feedback_provider.dart';

class FeedbackRepository {
  final exchangeApiProvider = FeedbackApiProvider();

  Future<List<Feedback>> fetchFeedbacks(String adsUserId) =>
      exchangeApiProvider.fetchFeedbacks(adsUserId);

  Future<List<Feedback>> checkFeedbackExist(
          String adsUserId, String exUserId) =>
      exchangeApiProvider.checkFeedbackExist(adsUserId, exUserId);

  Future<Feedback> createFeedback(payload) =>
      exchangeApiProvider.createFeedback(payload);
}
