enum AppPage {
  splash('Splash', ''),
  logConsole('LogConsole', 'console'),
  home('Home', 'home'),
  detail('Detail', 'detail');

  const AppPage(this.name, this.path);

  final String name;
  final String path;

  String get fullPath => '/$path';
}
