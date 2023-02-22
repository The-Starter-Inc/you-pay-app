import 'post.dart';

class Exchange {
  int id;
  int adsPostId;
  Post? post;
  String exDeviceId;
  int? userId;
  String? roomId;
  String? status;
  double amount;
  String createdAt;

  Exchange(
      {required this.id,
      required this.adsPostId,
      this.post,
      required this.amount,
      required this.exDeviceId,
      this.userId,
      this.status,
      this.roomId,
      required this.createdAt});

  static fromJson(parsedJson) {
    List<Exchange> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(Exchange(
          id: parsedJson[i]['id'],
          adsPostId: parsedJson[i]['ads_post_id'],
          post: Post.fromJsonObj(parsedJson[i]['post']),
          amount: double.parse((parsedJson[i]['amount'] ?? 0).toString())
              .toDouble(),
          exDeviceId: parsedJson[i]['ex_device_id'],
          userId: parsedJson[i]['user_id'],
          status: parsedJson[i]['status'],
          roomId: parsedJson[i]['room_id'],
          createdAt: parsedJson[i]['created_at']));
    }
    return results;
  }

  static fromJsonObj(parsedJson) {
    return Exchange(
        id: parsedJson['id'],
        adsPostId: parsedJson['ads_post_id'],
        //post: parsedJson['post'] ? Post.fromJsonObj(parsedJson['post']) : null,
        amount: double.parse((parsedJson['amount'] ?? 0).toString()).toDouble(),
        exDeviceId: parsedJson['ex_device_id'],
        userId: parsedJson['user_id'],
        status: parsedJson['status'],
        roomId: parsedJson['roomId'],
        createdAt: parsedJson['created_at']);
  }
}
