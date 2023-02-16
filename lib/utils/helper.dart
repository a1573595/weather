import 'package:url_launcher/url_launcher.dart' as urlLauncher;

launchUrl(String urlStr) async {
  final url = Uri.parse(urlStr);
  if (!await urlLauncher.launchUrl(url)) throw 'Could not launch $url';
}
