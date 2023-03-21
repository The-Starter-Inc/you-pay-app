import 'user.dart';

class Feedback {
  int id;
  String adsUserId;
  User adsUser;
  String exUserId;
  User exUser;
  String response;
  String createdAt;

  Feedback(
      {required this.id,
      required this.adsUserId,
      required this.adsUser,
      required this.exUserId,
      required this.exUser,
      required this.response,
      required this.createdAt});

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'adsUserId': adsUserId,
      'adsUser': adsUser.toMap(),
      'exUserId': exUserId,
      'exUser': exUser.toMap(),
      'response': response,
      'createdAt': createdAt
    };
  }
}
