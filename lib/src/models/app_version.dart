class AppVersion {
  int id;
  String androidVersionName;
  int androidVersionCode;
  int androidForceUpdateCode;
  bool androidForceUpdate;
  String iosVersionName;
  int iosVersionCode;
  int iosForceUpdateCode;
  bool iosForceUpdate;
  String createdAt;

  AppVersion(
      {required this.id,
      required this.androidVersionName,
      required this.androidVersionCode,
      required this.androidForceUpdateCode,
      required this.androidForceUpdate,
      required this.iosVersionName,
      required this.iosVersionCode,
      required this.iosForceUpdateCode,
      required this.iosForceUpdate,
      required this.createdAt});

  static fromMapArray(parsedJson) {
    List<AppVersion> results = [];
    for (int i = 0; i < parsedJson.length; i++) {
      results.add(fromMap(parsedJson[i]));
    }
    return results;
  }

  static fromMap(parsedJson) {
    return AppVersion(
        id: parsedJson['id'],
        androidVersionName: parsedJson['android_version_name'],
        androidVersionCode: parsedJson['android_version_code'],
        androidForceUpdateCode: parsedJson['android_force_update_code'],
        androidForceUpdate: parsedJson['android_force_update'],
        iosVersionName: parsedJson['ios_version_name'],
        iosVersionCode: parsedJson['ios_version_code'],
        iosForceUpdateCode: parsedJson['ios_force_update_code'],
        iosForceUpdate: parsedJson['ios_force_update'],
        createdAt: parsedJson['created_at']);
  }
}
