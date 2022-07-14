import 'package:json_annotation/json_annotation.dart';

import 'current.dart';
import 'daily.dart';
import 'hourly.dart';
import 'minutely.dart';

part 'one_call.g.dart';

@JsonSerializable()
class OneCall {
  OneCall(this.lat, this.lon, this.timezone, this.timezoneOffset, this.current,
      this.minutely, this.hourly, this.daily);

  double lat;
  double lon;
  String timezone;
  @JsonKey(name: 'timezone_offset')
  int timezoneOffset;
  Current current;
  List<Minutely> minutely;
  List<Hourly> hourly;
  List<Daily> daily;

  factory OneCall.fromJson(Map<String, dynamic> json) =>
      _$OneCallFromJson(json);

  Map<String, dynamic> toJson() => _$OneCallToJson(this);
}
