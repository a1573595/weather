import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseDio {
  static final BaseDio _instance = BaseDio._internal();

  static const defaultTimeout = Duration(seconds: 15);

  factory BaseDio() {
    return _instance;
  }

  BaseDio._internal();

  Dio getDio() {
    final Dio dio = Dio(BaseOptions(receiveTimeout: defaultTimeout, connectTimeout: defaultTimeout));

    dio.interceptors.add(PrettyDioLogger(requestBody: true, responseBody: true));

    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) => true;
      return client;
    };

    return dio;
  }
}
