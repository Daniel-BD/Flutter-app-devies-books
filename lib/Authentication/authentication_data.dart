class AuthenticationData {
  String _userId, _accessToken;

  String get userId => _userId;
  String get accessToken => _accessToken;

  bool get initialized => _userId.isNotEmpty && _accessToken.isNotEmpty;

  AuthenticationData.initEmpty()
      : _userId = '',
        _accessToken = '';

  AuthenticationData({
    required String userId,
    required String accessToken,
  })  : _userId = userId,
        _accessToken = accessToken;

  void updateAuthData({
    required String userId,
    required String accessToken,
  }) {
    _userId = userId;
    _accessToken = accessToken;
  }
}
