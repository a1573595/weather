part of 'home_page.dart';

var locationRequestProvider =
    FutureProvider.autoDispose<PermissionStatus>((ref) {
  return Permission.locationWhenInUse.request();
});

final isLocationEnableProvider =
StreamProvider.autoDispose<bool>((ref) {
  return Stream.periodic(const Duration(seconds: 3))
      .asyncMap((_) => Geolocator.isLocationServiceEnabled());
});