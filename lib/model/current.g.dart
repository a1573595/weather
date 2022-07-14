// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Current _$CurrentFromJson(Map<String, dynamic> json) => Current(
      json['dt'] as int,
      json['sunrise'] as int,
      json['sunset'] as int,
      (json['temp'] as num).toDouble(),
      (json['feels_like'] as num).toDouble(),
      json['pressure'] as int,
      json['humidity'] as int,
      (json['dew_point'] as num).toDouble(),
      (json['uvi'] as num).toDouble(),
      json['clouds'] as int,
      json['visibility'] as int,
      (json['wind_speed'] as num).toDouble(),
      json['wind_deg'] as int,
      (json['wind_gust'] as num?)?.toDouble(),
      (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CurrentToJson(Current instance) => <String, dynamic>{
      'dt': instance.dt,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
      'dew_point': instance.dewPoint,
      'uvi': instance.uvi,
      'clouds': instance.clouds,
      'visibility': instance.visibility,
      'wind_speed': instance.windSpeed,
      'wind_deg': instance.windDeg,
      'wind_gust': instance.windGust,
      'weather': instance.weathers,
    };
