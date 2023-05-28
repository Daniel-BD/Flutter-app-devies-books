import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Authentication/authentication_data.dart';
import '../api/open_api.dart';
import 'book_model.dart';

class BooksRepository {
  final String _cacheKey = 'books';

  Future<List<Book>> getAllBooks() async {
    final authData = GetIt.I<AuthenticationData>();
    final accessToken =
        authData.accessToken.isEmpty ? null : authData.accessToken;

    final books = await OpenApi.getAllBooks(accessToken);
    _cacheBooks(books);
    return books;
  }

  Future<List<Book>?> rateBook(String bookId, int rating) async {
    assert(rating >= 0 && rating <= 5, 'Invalid rating value');
    final authData = GetIt.I<AuthenticationData>();
    if (!authData.initialized) return null;

    final ratedBook = await OpenApi.rateBook(
      bookId: bookId,
      rating: rating,
      accessToken: authData.accessToken,
    );

    final updatedBooksCache = await getCachedBooks();
    if (updatedBooksCache.firstWhereOrNull((b) => b.id == ratedBook.id) !=
        null) {
      final index = updatedBooksCache.indexWhere((b) => b.id == ratedBook.id);
      updatedBooksCache[index] = ratedBook;
    }

    await _cacheBooks(updatedBooksCache);

    return updatedBooksCache;
  }

  Future<List<Book>> addNewBook({
    required NewBook newBook,
    required String accessToken,
  }) async {
    final book =
        await OpenApi.addNewBook(newBook: newBook, accessToken: accessToken);
    final newCache = [...(await getCachedBooks()), book];
    _cacheBooks(newCache);
    return newCache;
  }

  Future<List<Book>> getCachedBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = prefs.getString(_cacheKey);
    if (booksJson != null) {
      final List<dynamic> bookList = jsonDecode(booksJson);
      final List<Book> books =
          bookList.map((json) => Book.fromJson(json)).toList();
      return books;
    }
    return [];
  }

  Future<void> _cacheBooks(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    final booksJson = jsonEncode(books.map((book) => book.toJson()).toList());
    await prefs.setString(_cacheKey, booksJson);
  }
}
