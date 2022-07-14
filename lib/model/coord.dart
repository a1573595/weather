import 'package:json_annotation/json_annotation.dart';

part 'coord.g.dart';

@JsonSerializable()
class Coord {
  Coord(this.lon, this.lat);

  double lon;
  double lat;

  factory Coord.fromJson(Map<String, dynamic> json) =>
      _$CoordFromJson(json);

  Map<String, dynamic> toJson() => _$CoordToJson(this);
}
