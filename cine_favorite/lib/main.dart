import 'package:cine_favorite/views/login_view.dart';
import 'package:cine_favorite/views/favorite_view.dart';
import 'package:cine_favorite/views/search_view.dart';
import 'package:cine_favorite/views/register_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const CineFavoriteApp());
}

class CineFavoriteApp extends StatelessWidget {
  const CineFavoriteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      brightness: Brightness.dark,
      useMaterial3: false,
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Roboto'),
    );

    return MaterialApp(
      title: "Cine Favorite",
      theme: base.copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (c) => const LoginView(),
        '/register': (c) => const RegisterView(),
        '/search': (c) => const SearchView(),
        '/favorites': (c) => const FavoriteView(),
      },
      home: const AuthStream(),
    );
  }
}

class AuthStream extends StatelessWidget {
  const AuthStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) return const FavoriteView();
        return const LoginView();
      },
    );
  }
}
