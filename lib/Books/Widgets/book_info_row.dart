import 'package:devies_books/Books/book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookInfoRow extends StatelessWidget {
  final Book book;

  const BookInfoRow({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final averageRating = book.averageRating;

    const divider = Divider(height: 16);
    const verticalDivider = VerticalDivider(
      indent: 4,
      endIndent: 4,
      width: 24,
    );

    return Column(
      children: [
        divider,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: IntrinsicHeight(
              child: IntrinsicWidth(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BookInfoItem(
                      info: book.genre ?? 'N/A',
                      label: 'Genre',
                    ),
                    verticalDivider,
                    BookInfoItem(
                      info: averageRating?.toStringAsFixed(1) ?? 'N/A',
                      label: 'Rating',
                      icon: CupertinoIcons.star_fill,
                    ),
                    verticalDivider,
                    BookInfoItem(
                      info: book.haveRead?.toStringAsFixed(0) ?? 'N/A',
                      label: 'Have read',
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                    verticalDivider,
                    BookInfoItem(
                      info: book.wantToRead?.toStringAsFixed(0) ?? 'N/A',
                      label: 'Want to read',
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        divider,
      ],
    );
  }
}

class BookInfoItem extends StatelessWidget {
  const BookInfoItem({
    super.key,
    required this.label,
    required this.info,
    this.icon,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final IconData? icon;
  final String? label;
  final String info;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final iconData = icon;

    final children = [
      if (label != null)
        Text(
          label!,
          style: const TextStyle(fontSize: 12, color: Colors.black),
        ),
      Row(
        children: [
          if (iconData != null) ...[
            Icon(
              iconData,
              size: 16,
              color: Colors.black,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            info,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ];

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
