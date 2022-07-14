import 'package:json_annotation/json_annotation.dart';

part 'sys.g.dart';

@JsonSerializable()
class Sys {
  Sys(this.type, this.id, this.message, this.country, this.sunrise, this.sunset);

  int type;
  int id;
  int? message;
  String country;
  int sunrise;
  int sunset;

  factory Sys.fromJson(Map<String, dynamic> json) =>
      _$SysFromJson(json);

  Map<String, dynamic> toJson() => _$SysToJson(this);
}