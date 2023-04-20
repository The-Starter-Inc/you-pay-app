class Sponsor {
  int id;
  String? title;
  String? subtitle;
  String? type;
  String? description;
  ImageUrl? image;
  ImageUrl? banner;
  int timeout;
  int? priority;
  String createdAt;

  Sponsor(
      {required this.id,
      this.title,
      this.subtitle,
      this.type,
      this.description,
      this.image,
      this.banner,
      required this.timeout,
      this.priority,
      required this.createdAt});

  static fromMapArray(parsedJson) {
    List<Sponsor> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(fromMap(parsedJson[i]));
    }
    return results;
  }

  static fromMap(parsedJson) {
    return Sponsor(
        id: parsedJson['id'],
        title: parsedJson['title'],
        subtitle: parsedJson['subtitle'],
        type: parsedJson['type'],
        description: parsedJson['description'],
        image: ImageUrl(
            url: parsedJson['image'] != null ? parsedJson['image']['url'] : ""),
        banner: ImageUrl(
            url: parsedJson['banner'] != null
                ? parsedJson['banner']['url']
                : ""),
        timeout: parsedJson['timeout'],
        priority: parsedJson['priority'],
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
