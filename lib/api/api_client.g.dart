// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'https://api.openweathermap.org/data/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<CurrentWeather> currentWeather(lat, lng) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        CurrentWeather>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/2.5/weather?lat=${lat}&lon=${lng}&units=metric&appid=6adf87802066a3ee22591eb3f8abfe0c',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CurrentWeather.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OneCall> oneCall(lat, lng) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<
        OneCall>(Options(
            method: 'GET', headers: _headers, extra: _extra)
        .compose(_dio.options,
            '/2.5/onecall?lat=${lat}&lon=${lng}&units=metric&appid=6adf87802066a3ee22591eb3f8abfe0c',
            queryParameters: queryParameters, data: _data)
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OneCall.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
