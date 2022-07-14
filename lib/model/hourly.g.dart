// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hourly.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Hourly _$HourlyFromJson(Map<String, dynamic> json) => Hourly(
      json['dt'] as int,
      (json['temp'] as num).toDouble(),
      (json['feels_like'] as num).toDouble(),
      json['pressure'] as int,
      json['humidity'] as int,
      (json['dew_point'] as num).toDouble(),
      (json['uvi'] as num).toDouble(),
      json['clouds'] as int,
      json['visibility'] as int,
      (json['wind_speed'] as num).toDouble(),
      (json['wind_deg'] as num).toDouble(),
      (json['wind_gust'] as num?)?.toDouble(),
      (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['pop'] as num).toDouble(),
    );

Map<String, dynamic> _$HourlyToJson(Hourly instance) => <String, dynamic>{
      'dt': instance.dt,
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
      'pop': instance.pop,
    };
