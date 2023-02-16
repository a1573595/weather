import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final logger = _Logger();

class _Logger {
  static late Logger _logger;

  init({Logger? logger}) async {
    if (logger != null) {
      _logger = logger;
      return;
    }

    Directory? directory;

    try {
      if (!kIsWeb) {
        directory = await (Platform.isAndroid ? getExternalStorageDirectory() : getApplicationDocumentsDirectory());
      }
    } catch (_) {}

    /// 配置輸出在File與Console
    _logger = Logger(
        printer: PrettyPrinter(
          printTime: true,
        ),
        output: MultiOutput([
          if (directory != null)
            FileOutput(
              file: File('${directory.path}/log.txt'),
              overrideExisting: true,
            ),
          ConsoleOutput()
        ]));

    FlutterError.onError = (FlutterErrorDetails details) {
      _logger.e('Unhandled Exception:', details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _logger.e('Unhandled Exception:', error, stack);

      return true;
    };
  }

  v(dynamic message, [dynamic error, StackTrace? stackTrace]) => _logger.v(message, error, stackTrace);

  d(dynamic message, [dynamic error, StackTrace? stackTrace]) => _logger.d(message, error, stackTrace);

  i(dynamic message, [dynamic error, StackTrace? stackTrace]) => _logger.i(message, error, stackTrace);

  w(dynamic message, [dynamic error, StackTrace? stackTrace]) => _logger.w(message, error, stackTrace);

  e(dynamic message, [dynamic error, StackTrace? stackTrace]) => _logger.e(message, error, stackTrace);

  wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) => _logger.wtf(message, error, stackTrace);
}
