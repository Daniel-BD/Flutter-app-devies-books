import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../Public Users/public_user_controller.dart';
import '../../Public Users/public_users_model.dart';
import '../book_model.dart';
import '../books_controller.dart';
import 'book_info_row.dart';

class BookPage extends StatelessWidget {
  final Book book;

  const BookPage({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    final shelf = context.watch<PublicUserController>().publicUser?.shelf;
    final bookStatus = shelf?.firstWhereOrNull((b) => b.bookId == book.id);
    const pagePadding = EdgeInsets.symmetric(horizontal: 16);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: pagePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    Hero(
                      tag: 'cover ${book.id ?? book.name!}',
                      child: CachedNetworkImage(
                        imageUrl: book.coverUrl ?? '',
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.name ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (book.genre != null)
                      Text(
                        book.genre ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _circularButton(
                            context: context,
                            onPressed: () =>
                                _setBookStatus(context, Status.wantToRead),
                            icon: CupertinoIcons.add,
                            label: 'WANT TO READ',
                            value: (bookStatus?.status == Status.wantToRead) ==
                                true,
                          ),
                        ),
                        Expanded(
                          child: _circularButton(
                            context: context,
                            onPressed: () => _setBookStatus(
                                context, Status.currentlyReading),
                            icon: CupertinoIcons.book,
                            label: 'READING',
                            value: (bookStatus?.status ==
                                    Status.currentlyReading) ==
                                true,
                          ),
                        ),
                        Expanded(
                          child: _circularButton(
                            context: context,
                            onPressed: () =>
                                _setBookStatus(context, Status.haveRead),
                            icon: CupertinoIcons.checkmark,
                            label: 'HAVE READ',
                            value:
                                (bookStatus?.status == Status.haveRead) == true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              BookInfoRow(book: book),
              if (bookStatus?.status == Status.haveRead ||
                  bookStatus?.status == Status.currentlyReading) ...[
                Padding(
                  padding: pagePadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rate book:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      RatingBar.builder(
                        itemSize: 30,
                        initialRating: book.userRating?.toDouble() ?? 0,
                        minRating: 0,
                        maxRating: 5,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          final id = book.id;
                          if (id == null) return;
                          context.read<BooksController>().rateBook(
                                bookId: id,
                                rating: rating.floor(),
                              );
                        },
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
              Padding(
                padding: pagePadding,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(book.description ?? ''),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _circularButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool value,
    required BuildContext context,
  }) {
    final primaryColor = CupertinoTheme.of(context).primaryColor;
    return Column(
      children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: value ? primaryColor : null,
              shape: BoxShape.circle,
              border: Border.all(color: primaryColor, width: 2),
            ),
            child: Icon(
              icon,
              size: 22,
              color: value ? Colors.white : primaryColor,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _setBookStatus(BuildContext context, Status status) {
    final id = book.id;
    if (id == null) {
      assert(false, 'Book id should not be null');
      return;
    }
    context.read<PublicUserController>().addOrUpdateShelfItem(
          bookId: id,
          status: status,
        );
  }
}
