class ThemeEntity {
  String currentTheme;
  String id;

  ThemeEntity(
      {required this.currentTheme,
      required this.id});

  factory ThemeEntity.fromJson(Map<String, dynamic> parsedJson){
    return ThemeEntity(
        id: parsedJson['id'],
        currentTheme: parsedJson['currentTheme']
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'currentTheme': currentTheme,
      'id': id
    };
  }
}