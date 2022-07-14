import 'package:json_annotation/json_annotation.dart';

import 'coord.dart';
import 'weather.dart';
import 'main.dart';
import 'wind.dart';
import 'clouds.dart';
import 'sys.dart';

part 'current_weather.g.dart';

@JsonSerializable()
class CurrentWeather {
  CurrentWeather(
      this.coord,
      this.weathers,
      this.base,
      this.main,
      this.visibility,
      this.wind,
      this.clouds,
      this.dt,
      this.sys,
      this.timezone,
      this.id,
      this.name,
      this.cod);

  Coord coord;
  @JsonKey(name: 'weather')
  List<Weather> weathers;
  String base;
  Main main;
  int visibility;
  Wind wind;
  Clouds clouds;
  int dt;
  Sys sys;
  int timezone;
  int id;
  String name;
  int cod;

  factory CurrentWeather.fromJson(Map<String, dynamic> json) =>
      _$CurrentWeatherFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentWeatherToJson(this);
}
