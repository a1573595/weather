import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/router/app_router.dart';
import 'package:weather/utils/color_util.dart';
import 'package:weather/logger/logger.dart';
import 'package:weather/utils/text_util.dart';

void main() async {
  /// 確保Flutter能在APP開始前初始化
  WidgetsFlutterBinding.ensureInitialized();

  /// 初始化logger
  await logger.init();

  logger.i('Start App');

  /// 初始化RiverPod
  runApp(const ProviderScope(child: Weather()));
}

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

        /// Flutter app一定要有一個MaterialApp或CupertinoApp去開始一個App
        /// MaterialApp為Android style、CupertinoApp為ios style
        /// 後續仍可以混用雙方元件
        builder: (context, child) {
          var textTheme = customEnglishLike2018.apply(fontSizeFactor: 1.sp);

          return MaterialApp.router(
            /// 使用GoRouter取代Navigator管理路由
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
                      titleTextStyle:
                          textTheme.titleLarge?.copyWith(color: Colors.black),
                      iconTheme: const IconThemeData(color: Colors.black),
                    ),
                textTheme: textTheme,

                /// 過場動畫
                pageTransitionsTheme: const PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  },
                )),
          );
        });
  }
}
