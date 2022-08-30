import 'dart:io';

import 'package:dio/dio.dart';
// import 'package:hive_flutter/adapters.dart';

class HeaderInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // var box = Hive.box(tablePreferences);
    // var accessToken = box.get(keyAccessToken);
    //
    // if (accessToken != null) {
    //   options.headers['Authorization'] = 'Bearer $accessToken';
    //   options.headers['Content-Type'] = 'application/json';
    //   options.headers['accept'] = 'application/json';
    // }

    super.onRequest(options, handler);
  }
}
