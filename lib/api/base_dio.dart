import 'package:dio/dio.dart';

import '../logger/dio_logger.dart';

class BaseDio {
  /// Dart單例模式
  static final BaseDio _instance = BaseDio._internal();

  factory BaseDio() {
    return _instance;
  }

  BaseDio._internal();

  Dio getDio() {
    final Dio dio = Dio();
    /// 配置收送Timeout
    dio.options = BaseOptions(receiveTimeout: 15000, connectTimeout: 15000);
    dio.interceptors.add(DioLogger());
    // dio.interceptors.add(PrettyDioLogger(requestBody: true));

    return dio;
  }
}
