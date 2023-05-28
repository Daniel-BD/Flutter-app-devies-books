class PublicUser {
  final String id;
  final String username;
  final List<BookStatus> shelf;

  PublicUser({
    required this.id,
    required this.username,
    required this.shelf,
  });

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    final List<dynamic> shelfData = json['shelf'] ?? [];
    final List<BookStatus> shelf =
        shelfData.map((data) => BookStatus.fromJson(data)).toList();

    return PublicUser(
      id: json['id'],
      username: json['username'],
      shelf: shelf,
    );
  }

  Map<String, dynamic> toJson() {
    final shelfJson = shelf.map((status) => status.toJson()).toList();

    return {
      'id': id,
      'username': username,
      'shelf': shelfJson,
    };
  }
}

enum Status {
  haveRead,
  currentlyReading,
  wantToRead,
  noStatus;

  const Status();

  Map<String, dynamic> toJson() {
    return {
      'status': name,
    };
  }
}

class BookStatus {
  final String bookId;
  final Status status;

  BookStatus({
    required this.bookId,
    required this.status,
  });

  factory BookStatus.fromJson(Map<String, dynamic> json) {
    Status fromString(String value) {
      switch (value) {
        case 'haveRead':
          {
            return Status.haveRead;
          }
        case 'currentlyReading':
          {
            return Status.currentlyReading;
          }
        case 'wantToRead':
          {
            return Status.wantToRead;
          }
      }
      assert(false, 'String do not match Status enum');
      return Status.noStatus;
    }

    return BookStatus(
      bookId: json['bookId'],
      status: fromString(json['status']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'status': status,
    };
  }
}
