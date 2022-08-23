part of 'detail_page.dart';

final oneCallProvider = FutureProvider.autoDispose<OneCall>((ref) async {
  final cancelToken = CancelToken();

  /// 當Provider回收時將Request取消
  ref.onDispose(() => cancelToken.cancel());

  final repository = ref.read(weatherRepository);
  final response = await repository.oneCall(cancelToken: cancelToken);

  /// 請求成功後設定maintainState為true保留狀態
  /// 當不需要時要改為false才會被回收
  /// TODO('如何在外部關閉maintainState? ')
  ref.maintainState = true;

  return response;
});
