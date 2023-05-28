class Book {
  final String? id, name, genre, coverUrl, description;
  final num? averageRating, haveRead, currentlyReading, wantToRead, userRating;

  Book({
    required this.id,
    required this.name,
    required this.genre,
    required this.coverUrl,
    required this.description,
    required this.averageRating,
    required this.haveRead,
    required this.currentlyReading,
    required this.wantToRead,
    required this.userRating,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as String?,
      name: json['name'] as String?,
      genre: json['genre'] as String?,
      coverUrl: json['coverUrl'] as String?,
      description: json['description'] as String?,
      averageRating: json['averageRating'] as num?,
      haveRead: json['haveRead'] as num?,
      currentlyReading: json['currentlyReading'] as num?,
      wantToRead: json['wantToRead'] as num?,
      userRating: json['userRating'] as num?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'genre': genre,
      'coverUrl': coverUrl,
      'description': description,
      'averageRating': averageRating,
      'haveRead': haveRead,
      'currentlyReading': currentlyReading,
      'wantToRead': wantToRead,
      'userRating': userRating,
    };
  }
}

class NewBook {
  final String name;
  final String genre;
  final String coverUrl;
  final String description;

  NewBook({
    required this.name,
    required this.genre,
    required this.coverUrl,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'genre': genre,
      'coverUrl': coverUrl,
      'description': description,
    };
  }
}
