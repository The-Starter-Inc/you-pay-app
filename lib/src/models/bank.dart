class Bank {
  String icon;
  String name;
  static final List<Bank> _results = [];

  Bank({required this.icon, required this.name});

  static fromJson(Map<String, dynamic> parsedJson) {
    for (int i = 0; i < parsedJson.length; i++) {
      _results
          .add(Bank(icon: parsedJson[i]['icon'], name: parsedJson[i]['name']));
    }
  }

  List<Bank> get results => _results;
}
