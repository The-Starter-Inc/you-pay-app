import 'post.dart';

class Exchange {
  int id;
  int adsPostId;
  String adsUserId;
  String exUserId;
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
            exUserId: parsedJson[i]['ex_user_id'],
            post: Post.fromJsonObj(parsedJson[i]['post']),
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
        exUserId: parsedJson['ex_user_id'],
        //post: parsedJson['post'] ? Post.fromJsonObj(parsedJson['post']) : null,
        amount: double.parse((parsedJson['amount'] ?? 0).toString()).toDouble(),
        status: parsedJson['status'],
        roomId: parsedJson['room_id'],
        createdAt: parsedJson['created_at']);
  }
}
