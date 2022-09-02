import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/model/one_call.dart';

import '../api/weather_client.dart';
import '../model/current_weather.dart';

/// Provider只能被動監聽無法使用read改變狀態
/// autoDispose會在Provider沒有使用後自動回收
final weatherRepository = Provider.autoDispose((ref) => WeatherRepository(ref));

class WeatherRepository {
  WeatherRepository(this.ref);

  /// 讓Repository能夠存取其他Provider直接更新數值
  final Ref ref;

  Future<CurrentWeather> currentWeather({CancelToken? cancelToken}) async {
    Position position = await _determinePosition();
    return await WeatherClient().currentWeather(
        cancelToken ?? CancelToken(), position.latitude, position.longitude);
  }

  Future<OneCall> oneCall({CancelToken? cancelToken}) async {
    Position position = await _determinePosition();
    return await WeatherClient().oneCall(
        cancelToken ?? CancelToken(), position.latitude, position.longitude);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
