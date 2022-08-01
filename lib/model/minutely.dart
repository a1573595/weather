import 'package:json_annotation/json_annotation.dart';

part 'minutely.g.dart';

@JsonSerializable()
class Minutely {
  Minutely(this.dt, this.precipitation);

  int dt;
  double precipitation;

  factory Minutely.fromJson(Map<String, dynamic> json) =>
      _$MinutelyFromJson(json);

  Map<String, dynamic> toJson() => _$MinutelyToJson(this);
}
