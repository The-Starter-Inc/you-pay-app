import 'post.dart';
import 'user.dart';

class Exchange {
  int id;
  int adsPostId;
  String adsUserId;
  User? adsUser;
  String exUserId;
  User? exUser;
  String roomId;
  double amount;
  String? status;
  Post? post;
  String createdAt;

  Exchange(
      {required this.id,
      required this.adsPostId,
      required this.adsUserId,
      required this.exUserId,
      required this.roomId,
      required this.amount,
      this.adsUser,
      this.exUser,
      this.status,
      this.post,
      required this.createdAt});

  static fromJson(parsedJson) {
    List<Exchange> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      if (parsedJson[i]['post'] != null) {
        results.add(Exchange(
            id: parsedJson[i]['id'],
            adsPostId: parsedJson[i]['ads_post_id'],
            adsUserId: parsedJson[i]['ads_user_id'],
            adsUser: parsedJson[i]['ads_user'] != null
                ? User.fromMap(parsedJson[i]['ads_user'])
                : null,
            exUserId: parsedJson[i]['ex_user_id'],
            exUser: parsedJson[i]['ex_user'] != null
                ? User.fromMap(parsedJson[i]['ex_user'])
                : null,
            post: Post.fromMap(parsedJson[i]['post']),
            amount: double.parse((parsedJson[i]['amount'] ?? 0).toString())
                .toDouble(),
            status: parsedJson[i]['status'],
            roomId: parsedJson[i]['room_id'],
            createdAt: parsedJson[i]['created_at']));
      }
    }
    return results;
  }

  static fromJsonObj(parsedJson) {
    return Exchange(
        id: parsedJson['id'],
        adsPostId: parsedJson['ads_post_id'],
        adsUserId: parsedJson['ads_user_id'],
        adsUser: parsedJson['ads_user'] != null
            ? User.fromMap(parsedJson['ads_user'])
            : null,
        exUserId: parsedJson['ex_user_id'],
        exUser: parsedJson['ex_user'] != null
            ? User.fromMap(parsedJson['ex_user'])
            : null,
        //post: parsedJson['post'] ? Post.fromJsonObj(parsedJson['post']) : null,
        amount: double.parse((parsedJson['amount'] ?? 0).toString()).toDouble(),
        status: parsedJson['status'],
        roomId: parsedJson['room_id'],
        createdAt: parsedJson['created_at']);
  }
}
