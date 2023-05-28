import 'package:devies_books/Authentication/authenticated_user_controller.dart';
import 'package:devies_books/Books/books_controller.dart';
import 'package:devies_books/Public%20Users/public_user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Authentication/Widgets/login_page.dart';
import 'Authentication/authentication_data.dart';
import 'Books/Widgets/library_page.dart';

const resetPrefsOnStartup = true;

void main() async {
  if (resetPrefsOnStartup) {
    WidgetsFlutterBinding.ensureInitialized();
    await _removePrefs();
  }

  final getIt = GetIt.instance;
  getIt.registerSingleton<AuthenticationData>(AuthenticationData.initEmpty());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticatedUserController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerTheme: const DividerThemeData(thickness: 1),
      ),
      child: CupertinoApp(
        theme: CupertinoThemeData(
          scaffoldBackgroundColor: const Color(0xFFFFF9F0),
          primaryColor: const Color(0xFF4C4672),
          barBackgroundColor: const Color(0xFFF6EFE4),
          textTheme: CupertinoTextThemeData(
            textStyle: GoogleFonts.inter(
              color: Colors.black,
            ),
          ),
        ),
        home: Scaffold(
          body: Center(
            child: Builder(builder: (context) {
              final authInitialized =
                  context.watch<AuthenticatedUserController>().initialized;

              if (!authInitialized) {
                return const CupertinoActivityIndicator();
              }

              final authUser =
                  context.watch<AuthenticatedUserController>().user;

              if (authUser == null) {
                return LoginPage();
              }

              return MultiProvider(
                providers: [
                  ChangeNotifierProvider(
                    lazy: false,
                    create: (_) => BooksController(),
                  ),
                  ChangeNotifierProvider(
                    lazy: false,
                    create: (_) => PublicUserController(),
                  ),
                ],
                child: const LibraryPage(),
              );
            }),
          ),
        ),
      ),
    );
  }
}

Future<void> _removePrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}
