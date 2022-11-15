part of 'home_page.dart';

var _locationRequestProvider =
    FutureProvider.autoDispose<PermissionStatus>((ref) {
  return Permission.locationWhenInUse.request();
});

final _isLocationEnableProvider =
    Provider.autoDispose<AsyncValue<bool>>((ref) {
  return ref.watch(_isLocationEnableRefresh.select((value) => value));
});

final _isLocationEnableRefresh = StreamProvider.autoDispose<bool>((ref) {
  return Stream.periodic(const Duration(seconds: 5))
      .asyncMap((_) => Geolocator.isLocationServiceEnabled());
});

var _currentWeatherProvider = FutureProvider.autoDispose<CurrentWeather>((ref) {
  return ref.read(weatherRepository).currentWeather();
});
