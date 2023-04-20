class VerifiedUser {
  int id;
  String name;
  String phone;
  int priority;
  String createdAt;

  VerifiedUser(
      {required this.id,
      required this.name,
      required this.phone,
      required this.priority,
      required this.createdAt});

  static fromMapArray(parsedJson) {
    List<VerifiedUser> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(fromMap(parsedJson[i]));
    }
    return results;
  }

  static fromMap(parsedJson) {
    return VerifiedUser(
        id: parsedJson['id'],
        name: parsedJson['name'],
        phone: parsedJson['phone'],
        priority: parsedJson['priority'],
        createdAt: parsedJson['created_at']);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'priority': priority,
      'createdAt': createdAt
    };
  }
}
