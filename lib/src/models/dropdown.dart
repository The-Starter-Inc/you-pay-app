class DropDown {
  String id;
  String name;
  ImageUrl? icon;

  DropDown(this.id, this.name, this.icon);
}

class ImageUrl {
  String url;
  ImageUrl({required this.url});

  static dynamic toJson(ImageUrl imageUrl) {
    return {'url': imageUrl.url};
  }
}
