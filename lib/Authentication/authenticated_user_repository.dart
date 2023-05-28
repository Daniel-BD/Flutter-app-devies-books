import 'dart:async';
import 'dart:convert';

import 'package:devies_books/Authentication/authenticated_user_model.dart';
import 'package:devies_books/Authentication/authentication_data.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/open_api.dart';

class AuthenticatedUserRepository {
  final String _cacheKey = 'authenticatedUser';

  Future<AuthenticatedUser> registerUser({
    required String username,
    required String password,
  }) async {
    final cachedUser = await _getCachedUser();
    if (cachedUser != null && cachedUser.username == username) {
      return cachedUser;
    }

    final authenticatedUser = await OpenApi.registerUser(
      username: username,
      password: password,
    );
    await _cacheUser(authenticatedUser);
    _updateAuthData(authenticatedUser);
    return authenticatedUser;
  }

  Future<AuthenticatedUser> login({
    required String username,
    required String password,
  }) async {
    final cachedUser = await _getCachedUser();
    if (cachedUser != null && cachedUser.username == username) {
      final isLoggedIn = await OpenApi.isLoggedIn(
        accessToken: cachedUser.accessToken,
      );
      if (isLoggedIn) return cachedUser;
    }

    final authenticatedUser = await OpenApi.login(
      username: username,
      password: password,
    );
    await _cacheUser(authenticatedUser);
    _updateAuthData(authenticatedUser);
    return authenticatedUser;
  }

  Future<AuthenticatedUser?> init() async {
    final cachedUser = await _getCachedUser();
    if (cachedUser != null) {
      final isLoggedIn = await OpenApi.isLoggedIn(
        accessToken: cachedUser.accessToken,
      );
      if (isLoggedIn) {
        _updateAuthData(cachedUser);
        return cachedUser;
      }
    }
    return null;
  }

  Future<AuthenticatedUser?> _getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_cacheKey);
    if (userJson != null) {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return AuthenticatedUser.fromJson(userMap);
    }
    return null;
  }

  Future<void> _cacheUser(AuthenticatedUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_cacheKey, userJson);
  }

  void _updateAuthData(AuthenticatedUser user) {
    GetIt.I<AuthenticationData>().updateAuthData(
      userId: user.userId,
      accessToken: user.accessToken,
    );
  }
}
