class GeneralNoti {
  int id;
  String? title;
  String? subtitle;
  String? type;
  String? descriptions;
  String? linkToRedirect;
  String? messageId;
  ImageUrl? image;
  String createdAt;

  GeneralNoti(
      {required this.id,
      this.title,
      this.subtitle,
      this.type,
      this.descriptions,
      this.linkToRedirect,
      this.messageId,
      this.image,
      required this.createdAt});

  static fromMapArray(parsedJson) {
    List<GeneralNoti> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(fromMap(parsedJson[i]));
    }
    return results;
  }

  static fromMap(parsedJson) {
    return GeneralNoti(
        id: parsedJson['id'],
        title: parsedJson['title'],
        subtitle: parsedJson['subtitle'],
        type: parsedJson['type'],
        descriptions: parsedJson['descriptions'],
        linkToRedirect: parsedJson['link_to_redirect'],
        messageId: parsedJson['message_id'],
        image: ImageUrl(
            url: parsedJson['image'] != null ? parsedJson['image']['url'] : ""),
        createdAt: parsedJson['created_at']);
  }
}

class ImageUrl {
  String url;
  ImageUrl({required this.url});

  static dynamic toJson(ImageUrl imageUrl) {
    return {'url': imageUrl.url};
  }
}
