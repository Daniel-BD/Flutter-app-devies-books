import 'dart:convert';

import 'package:devies_books/Books/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../Authentication/authenticated_user_model.dart';
import '../Public Users/public_users_model.dart';
import '../api/api_constants.dart';

class OpenApi {
  static final _logger = Logger();

  /// Books

  static Future<Book> addNewBook({
    required NewBook newBook,
    required String accessToken,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.booksEndpoint),
      headers: ApiConstants.authorizedDefaultHeaders(accessToken),
      body: jsonEncode(newBook.toJson()),
    );

    if (response.statusCode == 201) {
      _logger
          .i('Successfully added new book to db. Response: ${response.body}');
      final json = jsonDecode(response.body);
      return Book.fromJson(json);
    } else {
      throw Exception(
          'Failed to post BookInfo. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  static Future<List<Book>> getAllBooks(String? accessToken) async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.booksEndpoint),
      headers: accessToken != null
          ? ApiConstants.authorizedDefaultHeaders(accessToken)
          : null,
    );

    if (response.statusCode == 200) {
      _logger.i(
          'Successfully fetched all books from db. Response: ${response.body}');
      final data = jsonDecode(response.body) as List<dynamic>;
      final books = data.map((json) => Book.fromJson(json)).toList();
      return books;
    } else {
      throw Exception(
          'Failed to load books. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  static Future<Book> getBookById(String bookId) async {
    final response = await http.get(
      Uri.parse(
          ApiConstants.baseUrl + ApiConstants.getBookByIdEndpoint(bookId)),
    );

    if (response.statusCode == 200) {
      _logger.i(
          'Successfully fetched book with id: $bookId from db. Response: ${response.body}');
      final json = jsonDecode(response.body);
      return Book.fromJson(json);
    } else {
      throw Exception(
          'Failed to load book. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  static Future<Book> rateBook({
    required String bookId,
    required int rating,
    required String accessToken,
  }) async {
    assert(rating >= 0 && rating <= 5, 'Invalid rating value');

    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.rateBookEndpoint(bookId)),
      headers: ApiConstants.authorizedDefaultHeaders(accessToken),
      body: jsonEncode({'bookId': bookId, 'rating': rating}),
    );

    if (response.statusCode == 201) {
      _logger.i(
          'Successfully posted book rating with id: $bookId to db. Response: ${response.body}');
      final json = jsonDecode(response.body);
      final book = Book.fromJson(json);
      return book;
    } else {
      throw Exception(
          'Failed to rate book. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  /// Users

  static Future<PublicUser> getUserById({
    required String userId,
    required String accessToken,
  }) async {
    final response = await http.get(
      Uri.parse(
          ApiConstants.baseUrl + ApiConstants.getUserByIdEndpoint(userId)),
      headers: ApiConstants.authorizedDefaultHeaders(accessToken),
    );

    if (response.statusCode == 200) {
      _logger.i(
          'Successfully fetched public user with id: $userId from db. Response: ${response.body}');
      final json = jsonDecode(response.body);
      return PublicUser.fromJson(json);
    } else {
      throw Exception(
          'Failed to get user. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  static Future<PublicUser> addShelfItem({
    required String userId,
    required String bookId,
    required Status status,
    required String accessToken,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.shelfEndpoint(userId)),
      headers: ApiConstants.authorizedDefaultHeaders(accessToken),
      body: jsonEncode({
        'bookId': bookId,
        'status': status.name,
      }),
    );

    if (response.statusCode == 201) {
      _logger.i(
          'Successfully added book to shelf. UserId: $userId, bookId: $bookId. Response: ${response.body}');
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PublicUser.fromJson(json);
    } else {
      throw Exception(
          'Failed to add book to shelf. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  static Future<PublicUser> updateShelfItem({
    required String userId,
    required String bookId,
    required Status status,
    required String accessToken,
  }) async {
    final response = await http.put(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.shelfEndpoint(userId)),
      headers: ApiConstants.authorizedDefaultHeaders(accessToken),
      body: jsonEncode({
        'bookId': bookId,
        'status': status.name,
      }),
    );

    if (response.statusCode == 200) {
      _logger.i(
          'Successfully updated book in shelf. UserId: $userId, bookId: $bookId. Response: ${response.body}');
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PublicUser.fromJson(json);
    } else {
      throw Exception(
          'Failed to update shelf. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  /// Auth

  static Future<AuthenticatedUser> registerUser({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.registerUserEndpoint),
      headers: ApiConstants.defaultHeaders,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      _logger.i(
          'Successfully registered user with username: $username. Response: ${response.body}');
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      jsonResponse['username'] = username;
      return AuthenticatedUser.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to register user. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  static Future<AuthenticatedUser> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.loginUserEndpoint),
      headers: ApiConstants.defaultHeaders,
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      _logger.i(
          'Successfully logged in user with username: $username. Response: ${response.body}');
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      jsonResponse['username'] = username;
      return AuthenticatedUser.fromJson(jsonResponse);
    } else {
      throw Exception(
          'Failed to login. Status code: ${response.statusCode}. Reason: ${response.reasonPhrase}');
    }
  }

  static Future<bool> isLoggedIn({required String accessToken}) async {
    final response = await http.get(
      Uri.parse(ApiConstants.baseUrl + ApiConstants.isLoggedInEndpoint),
      headers: ApiConstants.authorizedDefaultHeaders(accessToken),
    );

    if (response.statusCode == 200) {
      _logger.i('Successfully confirmed logged in. Response: ${response.body}');
      return true;
    } else {
      return false;
    }
  }
}
