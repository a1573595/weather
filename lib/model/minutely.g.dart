// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minutely.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Minutely _$MinutelyFromJson(Map<String, dynamic> json) => Minutely(
      json['dt'] as int,
      (json['precipitation'] as num).toDouble(),
    );

Map<String, dynamic> _$MinutelyToJson(Minutely instance) => <String, dynamic>{
      'dt': instance.dt,
      'precipitation': instance.precipitation,
    };
