part of 'home_page.dart';

var _locationRequestProvider =
    FutureProvider.autoDispose<PermissionStatus>((ref) {
  return Permission.locationWhenInUse.request();
});

final _isLocationEnableProvider =
StreamProvider.autoDispose<bool>((ref) {
  return Stream.periodic(const Duration(seconds: 3))
      .asyncMap((_) => Geolocator.isLocationServiceEnabled());
});