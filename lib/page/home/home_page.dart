import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather/router/app_page.dart';
import 'package:weather/utils/color_util.dart';

import '../../generated/l10n.dart';
import '../../model/current_weather.dart';
import '../../repository/WeatherRepository.dart';
import '../../utils/edge_util.dart';
import '../../utils/helper.dart';
import '../../utils/image_util.dart';
import '../../utils/lifecycle_event_handler.dart';

part 'home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  final String _url = 'https://github.com/a1573595';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.weather),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
            ),
            onPressed: () => launchUrl(_url),
          )
        ],
      ),
      body: const _LocationPermissionHandler(),
    );
  }
}

class _LocationPermissionHandler extends ConsumerWidget {
  const _LocationPermissionHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<PermissionStatus>(

        /// 三方權限請求
        /// ios需在Info.plist與Podfile額外宣告
        future: ref.watch(_locationRequestProvider.future),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var status = snapshot.data;
            if (status == PermissionStatus.granted ||
                status == PermissionStatus.limited) {
              return const _LocationEnableHandler();
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
          }
        });
  }
}

class _LocationEnableHandler extends ConsumerWidget {
  const _LocationEnableHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: ref.watch(_isLocationEnableProvider.stream),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            var status = snapshot.data;
            if (status == true) {
              return const _WeatherDataHandler();
            } else {
              return Center(
                child: ElevatedButton(
                    onPressed: () => Geolocator.openLocationSettings(),
                    child: Text(S.current.cant_get_location)),
              );
            }
          }
        });
  }
}

class _WeatherDataHandler extends ConsumerWidget {
  const _WeatherDataHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<CurrentWeather>(
        future: ref.read(weatherRepository).currentWeather(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _Body(snapshot.data!);
          }
        });
  }
}

class _Body extends StatelessWidget {
  const _Body(this.data, {Key? key}) : super(key: key);

  final CurrentWeather data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeUtil.listviewVerticalPadding,
      physics: const BouncingScrollPhysics(),
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
                  children: <Widget>[
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
                  children: <Widget>[
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
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140.0,
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeUtil.cardPadding,
                                child: Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: ColorUtil.lightBlue),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const FaIcon(FontAwesomeIcons.droplet,
                                      color: ColorUtil.lightBlue),
                                  Text(
                                    "  Humidity",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${data.main.humidity}%",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140.0,
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeUtil.cardPadding,
                                child: Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: ColorUtil.orangeAccent),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const FaIcon(FontAwesomeIcons.solidSun,
                                      color: ColorUtil.orangeAccent),
                                  Text(
                                    "  Visibility",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                data.visibility.toString() == 'null'
                                    ? 'N/A'
                                    : '${data.visibility} m',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140.0,
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeUtil.cardPadding,
                                child: Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: ColorUtil.greenAccent),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const FaIcon(FontAwesomeIcons.wind,
                                      color: ColorUtil.greenAccent),
                                  Text(
                                    "  Wind",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${data.wind.speed.toStringAsFixed(1)} km/h",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        child: Container(
                          alignment: Alignment.center,
                          width: 140.0,
                          height: 120.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeUtil.cardPadding,
                                child: Container(
                                  height: 5.0,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: ColorUtil.purpleAccent),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const FaIcon(FontAwesomeIcons.weightScale,
                                      color: ColorUtil.purpleAccent),
                                  Text(
                                    "  Pressure",
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${data.main.pressure} hPa",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
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
                router.go('${router.location}${AppPage.detail.fullPath}');
              },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(4),
                  backgroundColor: MaterialStateProperty.all(ColorUtil.orange)),
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
    );
  }
}
