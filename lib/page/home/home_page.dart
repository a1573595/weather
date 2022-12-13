import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather/generated/l10n.dart';
import 'package:weather/logger/log_console_on_shake.dart';
import 'package:weather/model/current_weather.dart';
import 'package:weather/repository/WeatherRepository.dart';
import 'package:weather/router/app_page.dart';
import 'package:weather/utils/color_util.dart';
import 'package:weather/utils/edge_util.dart';
import 'package:weather/utils/helper.dart';
import 'package:weather/utils/icon_util.dart';
import 'package:weather/utils/image_util.dart';
import 'package:weather/utils/lifecycle_event_handler.dart';
import 'package:weather/utils/notification_plugin.dart';
import 'package:weather/widget/detail_card.dart';

part 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final String _url = 'https://github.com/a1573595';

  @override
  Widget build(BuildContext context) {
    /// 震動監聽
    return LogConsoleOnShake(Scaffold(
      appBar: AppBar(
        title: Text(S.current.weather),
        actions: [
          /// svg assets
          IconButton(
            icon: SvgPicture.asset(IconUtil.info),
            onPressed: () => launchUrl(_url),
          ),
        ],
      ),
      body: _PopScope(),
    ));
  }
}

/// 偵測Back返回事件
class _PopScope extends StatelessWidget {
  _PopScope({Key? key}) : super(key: key);

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _popBack(context),

      /// permission_handler不支援Web
      /// 因此Web直接請求定位
      child: !kIsWeb
          ? const _LocationPermissionScope()
          : const _LocationEnableScope(),
    );
  }

  Future<bool> _popBack(BuildContext context) async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;

      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(S.current.press_again_to_exit),
      ));

      return false;
    }
    return true;
  }
}

/// 檢測定位是否授權
class _LocationPermissionScope extends ConsumerWidget {
  const _LocationPermissionScope({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 三方權限請求
    /// ios需在Info.plist與Podfile額外宣告
    var locationRequest = ref.watch(_locationRequestProvider);

    return locationRequest.when(
        data: (data) {
          if (data == PermissionStatus.granted ||
              data == PermissionStatus.limited) {
            return const _LocationEnableScope();
          } else {
            /// 監聽APP是否從背景返回（ex.修改權限）
            WidgetsBinding.instance.addObserver(LifecycleEventHandler(

                /// 刷新Provider
                resumeCallBack: () => ref.refresh(_locationRequestProvider)));

            return Center(
              child: ElevatedButton(
                  onPressed: () => Geolocator.openAppSettings(),
                  child: Text(S.current.cant_get_permission)),
            );
          }
        },
        error: (e, st) => Text(e.toString()),
        loading: () => const Center(child: CircularProgressIndicator()));
  }
}

/// 檢測定位是否開啟
class _LocationEnableScope extends ConsumerWidget {
  const _LocationEnableScope({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var locationEnable = ref.watch(_isLocationEnableProvider);

    return locationEnable.when(
        data: (data) {
          if (data == true) {
            return const _WeatherDataHandler();
          } else {
            return Center(
              child: ElevatedButton(
                  onPressed: () => Geolocator.openLocationSettings(),
                  child: Text(S.current.cant_get_location)),
            );
          }
        },
        error: (e, st) => Text(e.toString()),
        loading: () => const Center(child: CircularProgressIndicator()));

    /// StreamBuilder會Rebuild
    // return StreamBuilder(
    //     stream: ref.watch(_isLocationEnableProvider.stream),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         return Text(snapshot.error.toString());
    //       } else if (!snapshot.hasData) {
    //         return const Center(child: CircularProgressIndicator());
    //       } else {
    //         var status = snapshot.data;
    //         if (status == true) {
    //           return const _WeatherDataHandler();
    //         } else {
    //           return Center(
    //             child: ElevatedButton(
    //                 onPressed: () => Geolocator.openLocationSettings(),
    //                 child: Text(S.current.cant_get_location)),
    //           );
    //         }
    //       }
    //     });
  }
}

class _WeatherDataHandler extends ConsumerWidget {
  const _WeatherDataHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// FutureBuilder在refresh時會觸發兩次
    /// 使用AsyncValue可以解決
    var currentWeather = ref.watch(_currentWeatherProvider);
    return currentWeather.when(
        data: (data) {
          notificationUtil.sendNormal(data.weathers[0].description,
              '${data.main.temp.toStringAsFixed(0)}°',
              notificationId: 1);

          return _Body(data);
        },
        error: (e, st) => Text(e.toString()),
        loading: () => const _BlankBody());
  }
}

class _BlankBody extends StatelessWidget {
  const _BlankBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeUtil.screenPadding,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Text(
                '',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Text(
                '',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                )),
          ),
          const SizedBox(
            height: 40,
          ),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Text(
                '',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    )),
              )),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    )),
              )),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    )),
              )),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                    width: double.infinity,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: Colors.white,
                    )),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  _Body(this.data, {Key? key}) : super(key: key);

  final CurrentWeather data;

  final EasyRefreshController _controller = EasyRefreshController(
    controlFinishRefresh: true,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return EasyRefresh(
      controller: _controller,
      header: const ClassicHeader(),
      footer: const ClassicFooter(),
      onRefresh: () async {
        await ref.refresh(_currentWeatherProvider);
        _controller.finishRefresh();
        _controller.resetFooter();
      },
      child: SingleChildScrollView(
        padding: EdgeUtil.listviewVerticalPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  DateFormat("EEEE, d MMMM").format(
                      DateTime.fromMillisecondsSinceEpoch(data.dt * 1000)),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                      backgroundColor:
                          MaterialStateProperty.all(ColorUtil.orange)),
                  child: Container(
                    alignment: Alignment.center,
                    width: 80.0,
                    child: Text(
                      "Today",
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: ColorUtil.white),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeUtil.screenPadding,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(ImageUtil.header), fit: BoxFit.cover),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    S.current.day_temp_night_temp(
                        "${(data.main.tempMax).toInt()}",
                        "${(data.main.tempMin).toInt()}"),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${data.main.temp.toStringAsFixed(0)}°',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        S.current
                            .feels_like(data.main.feelsLike.toStringAsFixed(0)),
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CachedNetworkImage(
                        height: 40,
                        width: 40,
                        imageUrl:
                            '${ImageUtil.openWeatherImageUrlPrefix}${data.weathers[0].icon}.png',
                        placeholder: (context, url) => const SizedBox(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      data.weathers[0].description.contains(' ')
                          ? Text(
                              '${data.weathers[0].description.split(' ')[0][0].toUpperCase()}${data.weathers[0].description.split(' ')[0].substring(1)} ${data.weathers[0].description.split(' ')[1][0].toUpperCase()}${data.weathers[0].description.split(' ')[1].substring(1)}',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            )
                          : Text(
                              data.weathers[0].description[0].toUpperCase() +
                                  data.weathers[0].description.substring(1),
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                      const SizedBox(height: 8)
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeUtil.screenHorizontalPadding,
              alignment: Alignment.centerLeft,
              child: Text(
                'Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeUtil.screenHorizontalPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: DetailCard(
                            ColorUtil.lightBlue,
                            FontAwesomeIcons.droplet,
                            "Humidity",
                            "${data.main.humidity}%"),
                      ),
                      Expanded(
                        child: DetailCard(
                            ColorUtil.orangeAccent,
                            FontAwesomeIcons.solidSun,
                            "Visibility",
                            data.visibility.toString() == 'null'
                                ? 'N/A'
                                : '${data.visibility} m'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: DetailCard(
                            ColorUtil.greenAccent,
                            FontAwesomeIcons.wind,
                            "Wind",
                            "${data.wind.speed.toStringAsFixed(1)} km/h"),
                      ),
                      Expanded(
                        child: DetailCard(
                            ColorUtil.purpleAccent,
                            FontAwesomeIcons.weightScale,
                            "Pressure",
                            "${data.main.pressure} hPa"),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  var router = GoRouter.of(context);

                  /// 前往/home.detail
                  router
                      .go('${AppPage.home.fullPath}${AppPage.detail.fullPath}');
                },
                style: ElevatedButton.styleFrom(
                    elevation: 4, backgroundColor: ColorUtil.orange),
                child: Text(
                  "More Detail",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: ColorUtil.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
