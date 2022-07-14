// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Temp _$TempFromJson(Map<String, dynamic> json) => Temp(
      (json['day'] as num).toDouble(),
      (json['min'] as num).toDouble(),
      (json['max'] as num).toDouble(),
      (json['night'] as num).toDouble(),
      (json['eve'] as num).toDouble(),
      (json['morn'] as num).toDouble(),
    );

Map<String, dynamic> _$TempToJson(Temp instance) => <String, dynamic>{
      'day': instance.day,
      'min': instance.min,
      'max': instance.max,
      'night': instance.night,
      'eve': instance.eve,
      'morn': instance.morn,
    };
