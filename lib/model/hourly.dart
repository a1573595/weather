import 'package:json_annotation/json_annotation.dart';
import 'package:weather/model/weather.dart';

part 'hourly.g.dart';

@JsonSerializable()
class Hourly {
  Hourly(
      this.dt,
      this.temp,
      this.feelsLike,
      this.pressure,
      this.humidity,
      this.dewPoint,
      this.uvi,
      this.clouds,
      this.visibility,
      this.windSpeed,
      this.windDeg,
      this.windGust,
      this.weathers,
      this.pop);

  int dt;
  double temp;
  @JsonKey(name: 'feels_like')
  double feelsLike;
  int pressure;
  int humidity;
  @JsonKey(name: 'dew_point')
  double dewPoint;
  double uvi;
  int clouds;
  int visibility;
  @JsonKey(name: 'wind_speed')
  double windSpeed;
  @JsonKey(name: 'wind_deg')
  double windDeg;
  @JsonKey(name: 'wind_gust')
  double? windGust;
  @JsonKey(name: 'weather')
  List<Weather> weathers;
  double pop;

  factory Hourly.fromJson(Map<String, dynamic> json) => _$HourlyFromJson(json);

  Map<String, dynamic> toJson() => _$HourlyToJson(this);
}
