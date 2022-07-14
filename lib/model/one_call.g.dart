// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneCall _$OneCallFromJson(Map<String, dynamic> json) => OneCall(
      (json['lat'] as num).toDouble(),
      (json['lon'] as num).toDouble(),
      json['timezone'] as String,
      json['timezone_offset'] as int,
      Current.fromJson(json['current'] as Map<String, dynamic>),
      (json['minutely'] as List<dynamic>)
          .map((e) => Minutely.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['hourly'] as List<dynamic>)
          .map((e) => Hourly.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['daily'] as List<dynamic>)
          .map((e) => Daily.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OneCallToJson(OneCall instance) => <String, dynamic>{
      'lat': instance.lat,
      'lon': instance.lon,
      'timezone': instance.timezone,
      'timezone_offset': instance.timezoneOffset,
      'current': instance.current,
      'minutely': instance.minutely,
      'hourly': instance.hourly,
      'daily': instance.daily,
    };
