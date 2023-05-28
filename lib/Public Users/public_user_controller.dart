import 'package:devies_books/Public%20Users/public_user_repository.dart';
import 'package:devies_books/Public%20Users/public_users_model.dart';
import 'package:flutter/material.dart';

class PublicUserController extends ChangeNotifier {
  final _publicUserRepository = PublicUserRepository();
  PublicUser? _publicUser;
  PublicUser? get publicUser => _publicUser;
  bool initialized = false;

  PublicUserController() {
    _init();
  }

  Future<void> _init() async {
    _publicUser = await _publicUserRepository.getPublicUser();
    initialized = true;
    notifyListeners();
  }

  Future<void> addOrUpdateShelfItem({
    required String bookId,
    required Status status,
  }) async {
    final isInShelf =
        _publicUser?.shelf.where((b) => b.bookId == bookId).isNotEmpty == true;

    _publicUser = isInShelf
        ? await _publicUserRepository.updateShelfItem(
            bookId: bookId,
            status: status,
          )
        : await _publicUserRepository.addShelfItem(
            bookId: bookId,
            status: status,
          );
    notifyListeners();
  }
}
