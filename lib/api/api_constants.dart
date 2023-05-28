class ApiConstants {
  static String baseUrl = 'https://devies-reads-be.onrender.com';
  static String registerUserEndpoint = '/auth/register';
  static String loginUserEndpoint = '/auth/login';
  static String isLoggedInEndpoint = '/is-logged-in';
  static String booksEndpoint = '/books';
  static String usersEndpoint = '/users';

  static String getBookByIdEndpoint(String id) {
    return '$booksEndpoint/$id';
  }

  static String rateBookEndpoint(String id) {
    return '$booksEndpoint/$id/rate';
  }

  static String getUserByIdEndpoint(String id) {
    return '$usersEndpoint/$id';
  }

  static String shelfEndpoint(String id) {
    return '$usersEndpoint/$id/shelf';
  }

  static Map<String, String> authorizedDefaultHeaders(String accessToken) {
    return {'Authorization': 'Bearer $accessToken', ...defaultHeaders};
  }

  static Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
}
