import 'package:cached_network_image/cached_network_image.dart';
import 'package:devies_books/Books/Widgets/book_page.dart';
import 'package:devies_books/Public%20Users/public_user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../book_model.dart';
import '../books_controller.dart';

class BookWidget extends StatelessWidget {
  final Book book;
  const BookWidget({required this.book, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => MultiProvider(
                providers: [
                  ChangeNotifierProvider.value(
                    value: context.read<BooksController>(),
                  ),
                  ChangeNotifierProvider.value(
                    value: context.read<PublicUserController>(),
                  ),
                ],
                child: BookPage(book: book),
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'cover ${book.id ?? book.name!}',
              child: CachedNetworkImage(
                imageUrl: book.coverUrl ?? '',
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    const Center(
                  child: CupertinoActivityIndicator(),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(builder: (context) {
                      const textStyle = TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black,
                      );

                      return Text(
                        book.name ?? '',
                        style: textStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      );
                    }),
                    const SizedBox(height: 4),
                    _infoRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow() {
    const smallStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
    );

    const numberStyle = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );

    const verticalDivider = VerticalDivider(
      indent: 4,
      endIndent: 4,
      width: 24,
    );

    const verticalPadding = SizedBox(height: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          book.genre ?? '',
          style: smallStyle,
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            const Divider(height: 0, endIndent: 16),
            IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rating', style: smallStyle),
                        verticalPadding,
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.star_fill,
                              color: Colors.black,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              book.averageRating?.toStringAsFixed(1) ?? 'N/A',
                              style: numberStyle,
                            ),
                          ],
                        ),
                      ],
                    ),
                    verticalDivider,
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Have read', style: smallStyle),
                          verticalPadding,
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              book.haveRead?.toStringAsFixed(0) ?? 'N/A',
                              style: numberStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    verticalDivider,
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Want to read', style: smallStyle),
                          verticalPadding,
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              book.wantToRead?.toStringAsFixed(0) ?? 'N/A',
                              style: numberStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 0, endIndent: 16),
          ],
        ),
      ],
    );
  }
}
