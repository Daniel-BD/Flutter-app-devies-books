import 'package:flutter/material.dart';

import 'book_model.dart';
import 'books_repository.dart';

enum SortBooksBy { name, rating, wantToRead, haveRead }

class BooksController extends ChangeNotifier {
  final _bookRepository = BooksRepository();
  List<Book> _books = [];

  List<Book> get books => _books;

  BooksController() {
    _init();
  }

  Future<void> _init() async {
    _books = await _bookRepository.getCachedBooks();
    notifyListeners();
    _books = await _bookRepository.getAllBooks();
    notifyListeners();
  }

  void sortBy(SortBooksBy sortBy) {
    int Function(Book, Book)? compare;

    switch (sortBy) {
      case SortBooksBy.rating:
        compare =
            (a, b) => (b.averageRating ?? 0).compareTo(a.averageRating ?? 0);
        break;
      case SortBooksBy.wantToRead:
        compare = (a, b) => (b.wantToRead ?? 0).compareTo(a.wantToRead ?? 0);
        break;
      case SortBooksBy.haveRead:
        compare = (a, b) => (b.haveRead ?? 0).compareTo(a.haveRead ?? 0);
        break;
      default:
        compare = (a, b) => (a.name ?? '').compareTo(b.name ?? '');
    }

    _books.sort(compare);
    notifyListeners();
  }

  Future<void> getAllBooks() async {
    _books = await _bookRepository.getAllBooks();
    notifyListeners();
  }

  Future<void> addNewBook({
    required NewBook newBook,
    required String accessToken,
  }) async {
    _books = await _bookRepository.addNewBook(
        newBook: newBook, accessToken: accessToken);
    notifyListeners();
  }

  Future<void> rateBook({required String bookId, required int rating}) async {
    assert(rating >= 0 && rating <= 5, 'Invalid rating value');
    final updatedBooks = await _bookRepository.rateBook(bookId, rating);

    if (updatedBooks != null) {
      _books = updatedBooks;
      notifyListeners();
    }
  }
}
