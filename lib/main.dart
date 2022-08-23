import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/router/app_router.dart';
import 'package:weather/utils/color_util.dart';
import 'package:weather/utils/logger.dart';

void main() async {
  /// 確保Flutter能在APP開始前初始化
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始化logger
  await logger.init();

  logger.i('Start App');

  /// 初始化RiverPod
  runApp(const ProviderScope(child: Weather()));
}

/// App text樣式
const TextTheme customEnglishLike2018 = TextTheme(
  displayLarge: TextStyle(
      debugLabel: 'englishLike displayLarge 2018',
      fontSize: 96.0,
      fontWeight: FontWeight.w700,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: -1.5,
      color: ColorUtil.black),
  displayMedium: TextStyle(
      debugLabel: 'englishLike displayMedium 2018',
      fontSize: 60.0,
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: -0.5,
      color: ColorUtil.black),
  displaySmall: TextStyle(
      debugLabel: 'englishLike displaySmall 2018',
      fontSize: 48.0,
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.0,
      color: ColorUtil.black),
  headlineLarge: TextStyle(
      debugLabel: 'englishLike headlineLarge 2018',
      fontSize: 40.0,
      fontWeight: FontWeight.w700,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.25,
      color: ColorUtil.black),
  headlineMedium: TextStyle(
      debugLabel: 'englishLike headlineMedium 2018',
      fontSize: 34.0,
      fontWeight: FontWeight.w600,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.25,
      color: ColorUtil.black),
  headlineSmall: TextStyle(
      debugLabel: 'englishLike headlineSmall 2018',
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.0,
      color: ColorUtil.black),
  titleLarge: TextStyle(
      debugLabel: 'englishLike titleLarge 2018',
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.15),
  titleMedium: TextStyle(
      debugLabel: 'englishLike titleMedium 2018',
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.15),
  titleSmall: TextStyle(
      debugLabel: 'englishLike titleSmall 2018',
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.1),
  bodyLarge: TextStyle(
      debugLabel: 'englishLike bodyLarge 2018',
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.5),
  bodyMedium: TextStyle(
      debugLabel: 'englishLike bodyMedium 2018',
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.25),
  bodySmall: TextStyle(
      debugLabel: 'englishLike bodySmall 2018',
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 0.4),
  labelLarge: TextStyle(
      debugLabel: 'englishLike labelLarge 2018',
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 1.25),
  labelMedium: TextStyle(
      debugLabel: 'englishLike labelMedium 2018',
      fontSize: 11.0,
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 1.5),
  labelSmall: TextStyle(
      debugLabel: 'englishLike labelSmall 2018',
      fontSize: 10.0,
      fontWeight: FontWeight.w400,
      textBaseline: TextBaseline.alphabetic,
      letterSpacing: 1.5),
);

class Weather extends StatelessWidget {
  const Weather({Key? key}) : super(key: key);

  /// 初始化ScreenUtilInit
  /// 載入App router並配置Theme
  @override
  Widget build(BuildContext context) {
    /// Router位置變更監聽
    /// 不知為何切換分支會trigger兩次
    String? lastLocation;
    rootRouter.addListener(() {
      if (lastLocation != rootRouter.location) {
        lastLocation = rootRouter.location;
        logger.i('Router change:  ${rootRouter.location}');
      }
    });

    return ScreenUtilInit(
        /// 自動調整最小字體
        minTextAdapt: true,
        /// 載入Router
        builder: (context, child) => MaterialApp.router(
              routeInformationProvider: rootRouter.routeInformationProvider,
              routeInformationParser: rootRouter.routeInformationParser,
              routerDelegate: rootRouter.routerDelegate,

              /// App名稱
              title: 'Weather',

              /// 多語系配置
              /// ios需要到Info.plist新增對應語言
              localizationsDelegates: const [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],

              /// 多語系支援區域
              supportedLocales: S.delegate.supportedLocales,
              theme: ThemeData(
                  scaffoldBackgroundColor: ColorUtil.backgroundColor,
                  primaryIconTheme: const IconThemeData(color: Colors.black),
                  appBarTheme: Theme.of(context).appBarTheme.copyWith(
                        elevation: 0,
                        centerTitle: true,
                        color: Colors.transparent,
                        titleTextStyle: customEnglishLike2018.titleLarge
                            ?.copyWith(color: Colors.black),
                        iconTheme: const IconThemeData(color: Colors.black),
                      ),
                  textTheme: customEnglishLike2018.apply(fontSizeFactor: 1.sp),

                  /// 過場動畫
                  pageTransitionsTheme: const PageTransitionsTheme(
                    builders: <TargetPlatform, PageTransitionsBuilder>{
                      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    },
                  )),
            ));
  }
}
