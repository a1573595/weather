import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../model/current_weather.dart';
import '../model/one_call.dart';
import 'base_dio.dart';

part 'weather_client.g.dart';

@RestApi(baseUrl: "https://api.openweathermap.org/data/")
abstract class WeatherClient {
  factory WeatherClient({Dio? dio, String? baseUrl}) {
    dio ??= BaseDio().getDio();
    return _WeatherClient(dio, baseUrl: baseUrl);
  }

  @GET(
      "/2.5/weather?lat={lat}&lon={lon}&units=metric&appid=6adf87802066a3ee22591eb3f8abfe0c")
  Future<CurrentWeather> currentWeather(@CancelRequest() CancelToken cancelToken,
      @Path('lat') double lat, @Path('lon') double lng);

  @GET(
      "/2.5/onecall?lat={lat}&lon={lon}&units=metric&appid=6adf87802066a3ee22591eb3f8abfe0c")
  Future<OneCall> oneCall(@CancelRequest() CancelToken cancelToken, @Path('lat') double lat, @Path('lon') double lng);
}
