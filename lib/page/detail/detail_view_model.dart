part of 'detail_page.dart';

final _oneCallProvider = FutureProvider.autoDispose<OneCall>((ref) async {
  /// 當Provider回收時將Request取消
  final cancelToken = CancelToken();
  ref.onDispose(() => cancelToken.cancel());

  final repository = ref.read(weatherRepository);
  final response = await repository.oneCall(cancelToken: cancelToken);

  /// 保留10分鐘狀態緩存
  var link = ref.keepAlive();
  final timer = Timer(const Duration(minutes: 10), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());

  return response;
});
