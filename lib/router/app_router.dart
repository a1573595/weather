import 'package:go_router/go_router.dart';
import 'package:weather/page/detail/detail_page.dart';
import 'package:weather/page/home/home_page.dart';
import 'package:weather/page/splash/splash_page.dart';

import '../page/console/log_console_page.dart';
import 'app_page.dart';

/// Router根目錄
final rootRouter = GoRouter(routes: [
  GoRoute(
    name: AppPage.splash.name,
    path: AppPage.splash.fullPath,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    name: AppPage.logConsole.name,
    path: AppPage.logConsole.fullPath,
    builder: (context, state) => const LogConsolePage(),
  ),

  /// home與splash分支獨立分開撰寫
  GoRoute(
      name: AppPage.home.name,
      path: AppPage.home.fullPath,
      builder: (context, state) => const HomePage(),
      routes: [
        /// detail依賴於home因此寫在detail內
        GoRoute(
            name: AppPage.detail.name,
            path: AppPage.detail.path,
            builder: (context, state) => const DetailPage(),
            routes: []),
      ]),
]);
