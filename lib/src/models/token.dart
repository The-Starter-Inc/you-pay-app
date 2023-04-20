class Token {
  String token_type;
  int expires_in;
  String access_token;

  Token(
      {required this.token_type,
      required this.expires_in,
      required this.access_token});

  static fromJson(Map<String, dynamic> parsedJson) {
    return Token(
        token_type: parsedJson['token_type'],
        expires_in: parsedJson['expires_in'],
        access_token: parsedJson['access_token']);
  }
}
