class AuthenticatedUser {
  final String username, userId, accessToken;

  AuthenticatedUser({
    required this.username,
    required this.userId,
    required this.accessToken,
  });

  factory AuthenticatedUser.fromJson(Map<String, dynamic> json) {
    return AuthenticatedUser(
      username: json['username'] as String,
      userId: json['userId'] as String,
      accessToken: json['accessToken'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'userId': userId,
      'accessToken': accessToken,
    };
  }
}
