import 'package:url_launcher/url_launcher.dart' as urlLauncher;

// 其他地方無法呼叫
extension on String {
  void launchUrl() async {
    final url = Uri.parse(this);
    if (!await urlLauncher.launchUrl(url)) throw 'Could not launch $url';
  }
}

launchUrl(String urlStr) async {
  final url = Uri.parse(urlStr);
  if (!await urlLauncher.launchUrl(url)) throw 'Could not launch $url';
}

extension ExtendedIterable<E> on Iterable<E> {
  /// Like Iterable<T>.map but the callback has index as second argument
  Iterable<T> mapIndexed<T>(T Function(int i, E e) f) {
    var i = 0;
    return map((e) => f(i++, e));
  }

  void forEachIndexed(void Function(int i, E e) f) {
    var i = 0;
    forEach((e) => f(i++, e));
  }
}
