import 'user.dart';

class Feedback {
  int? id;
  String adsUserId;
  User adsUser;
  String exUserId;
  User exUser;
  String response;
  String? createdAt;

  Feedback(
      {this.id,
      required this.adsUserId,
      required this.adsUser,
      required this.exUserId,
      required this.exUser,
      required this.response,
      this.createdAt});

  static fromMapArray(parsedJson) {
    List<Feedback> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(fromMap(parsedJson[i]));
    }
    return results;
  }

  static fromMap(parsedJson) {
    return Feedback(
        id: parsedJson['id'],
        adsUserId: parsedJson['ads_user_id'],
        adsUser: User.fromMap(parsedJson['ads_user']),
        exUserId: parsedJson['ex_user_id'],
        exUser: User.fromMap(parsedJson['ex_user']),
        response: parsedJson['response'],
        createdAt: parsedJson['created_at']);
  }

  toJson() {
    return {
      'ads_user_id': adsUserId,
      'ads_user': adsUser.toJson(),
      'ex_user_id': exUserId,
      'ex_user': exUser.toJson(),
      'response': response,
    };
  }
}
