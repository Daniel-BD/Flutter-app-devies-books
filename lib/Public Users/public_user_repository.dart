import 'dart:async';
import 'dart:convert';

import 'package:devies_books/Public%20Users/public_users_model.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/authentication_data.dart';
import '../api/open_api.dart';

class PublicUserRepository {
  final String _cacheKey = 'publicUser';

  Future<PublicUser?> getPublicUser() async {
    final authData = GetIt.I<AuthenticationData>();
    if (!authData.initialized) return null;
    final user = await OpenApi.getUserById(
      userId: authData.userId,
      accessToken: authData.accessToken,
    );
    _cacheUser(user);
    return user;
  }

  Future<PublicUser?> addShelfItem({
    required String bookId,
    required Status status,
  }) async {
    final authData = GetIt.I<AuthenticationData>();
    if (!authData.initialized) return null;

    final user = await OpenApi.addShelfItem(
      bookId: bookId,
      status: status,
      userId: authData.userId,
      accessToken: authData.accessToken,
    );
    _cacheUser(user);
    return user;
  }

  Future<PublicUser?> updateShelfItem({
    required String bookId,
    required Status status,
  }) async {
    final authData = GetIt.I<AuthenticationData>();
    if (!authData.initialized) return null;

    final user = await OpenApi.updateShelfItem(
      bookId: bookId,
      status: status,
      userId: authData.userId,
      accessToken: authData.accessToken,
    );
    _cacheUser(user);
    return user;
  }

  Future<PublicUser?> getCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_cacheKey);
    if (userJson != null) {
      return PublicUser.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<void> _cacheUser(PublicUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_cacheKey, userJson);
  }
}
