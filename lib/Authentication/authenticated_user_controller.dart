import 'package:devies_books/Authentication/authenticated_user_model.dart';
import 'package:devies_books/Authentication/authenticated_user_repository.dart';
import 'package:flutter/material.dart';

class AuthenticatedUserController extends ChangeNotifier {
  final _userRepository = AuthenticatedUserRepository();
  AuthenticatedUser? _user;
  AuthenticatedUser? get user => _user;
  bool initialized = false;

  AuthenticatedUserController() {
    _init();
  }

  Future<void> _init() async {
    final user = await _userRepository.init();
    if (user != null) _user = user;
    initialized = true;
    notifyListeners();
  }

  Future<void> login({
    required String username,
    required password,
  }) async {
    _user = await _userRepository.login(
      username: username,
      password: password,
    );
    notifyListeners();
  }

  Future<void> registerUser({
    required String username,
    required password,
  }) async {
    _user = await _userRepository.registerUser(
      username: username,
      password: password,
    );
    notifyListeners();
  }
}
