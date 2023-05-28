import 'package:devies_books/Books/Widgets/book_widget.dart';
import 'package:devies_books/Books/books_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  void _showActionSheet(BuildContext context) {
    final controller = context.read<BooksController>();

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Sort by:'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              controller.sortBy(SortBooksBy.name);
              Navigator.pop(context);
            },
            child: const Text('Name'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              controller.sortBy(SortBooksBy.rating);
              Navigator.pop(context);
            },
            child: const Text('Rating'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              controller.sortBy(SortBooksBy.haveRead);
              Navigator.pop(context);
            },
            child: const Text('Most have read'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              controller.sortBy(SortBooksBy.wantToRead);
              Navigator.pop(context);
            },
            child: const Text('Most want to read'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context);
          },
          isDefaultAction: true,
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BooksController>().books;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Library'),
        trailing: CupertinoButton(
          child: const Icon(
            CupertinoIcons.arrow_up_arrow_down_circle_fill,
          ),
          onPressed: () {
            _showActionSheet(context);
          },
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final book in books)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: BookWidget(
                  book: book,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
