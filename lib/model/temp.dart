import 'package:json_annotation/json_annotation.dart';

part 'temp.g.dart';

@JsonSerializable()
class Temp {
  Temp(this.day, this.min, this.max, this.night, this.eve, this.morn);

  double day;
  double min;
  double max;
  double night;
  double eve;
  double morn;

  factory Temp.fromJson(Map<String, dynamic> json) =>
      _$TempFromJson(json);

  Map<String, dynamic> toJson() => _$TempToJson(this);
}
