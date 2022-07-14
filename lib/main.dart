import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:weather/page/detail_page.dart';
import 'package:weather/page/splash_page.dart';

import 'page/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(const ProviderScope(child: MyApp()));
  });
}

final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage(),
          routes: <GoRoute>[
            GoRoute(
              path: 'detail',
              builder: (context, state) => const DetailPage(),
            ),
          ]),
    ]);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
        title: 'Weather',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            primaryColor: Colors.blue,
            primaryIconTheme: const IconThemeData(color: Colors.black),
            appBarTheme: const AppBarTheme(
                elevation: 0,
                centerTitle: true,
                color: Colors.white,
                titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
                iconTheme: IconThemeData(color: Colors.black))),
      );
}
