import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:weather/api/header_interceptor.dart';

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

    /// 配置標頭檔
    dio.interceptors.add(HeaderInterceptor());
    dio.interceptors.add(DioLogger());
    // dio.interceptors.add(PrettyDioLogger(requestBody: true));

    /// ignore certification
    String PEM = 'XXXXX'; // certificate content
    if (dio.httpClientAdapter is DefaultHttpClientAdapter) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, String host, int port) {
          // return cert.pem == PEM;
          return true;
        };
      };
    }
    /* else if(dio.httpClientAdapter is BrowserHttpClientAdapter) {

    } */

    return dio;
  }
}
