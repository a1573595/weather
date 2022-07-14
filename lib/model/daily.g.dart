// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Daily _$DailyFromJson(Map<String, dynamic> json) => Daily(
      json['dt'] as int,
      json['sunrise'] as int,
      json['sunset'] as int,
      json['moonrise'] as int,
      json['moonset'] as int,
      (json['moon_phase'] as num).toDouble(),
      Temp.fromJson(json['temp'] as Map<String, dynamic>),
      FeelsLike.fromJson(json['feels_like'] as Map<String, dynamic>),
      json['pressure'] as int,
      json['humidity'] as int,
      (json['dew_point'] as num).toDouble(),
      (json['wind_speed'] as num).toDouble(),
      json['wind_deg'] as int,
      (json['wind_gust'] as num?)?.toDouble(),
      (json['weather'] as List<dynamic>)
          .map((e) => Weather.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['clouds'] as int,
      (json['pop'] as num).toDouble(),
      (json['rain'] as num?)?.toDouble(),
      (json['uvi'] as num).toDouble(),
    );

Map<String, dynamic> _$DailyToJson(Daily instance) => <String, dynamic>{
      'dt': instance.dt,
      'sunrise': instance.sunrise,
      'sunset': instance.sunset,
      'moonrise': instance.moonrise,
      'moonset': instance.moonset,
      'moon_phase': instance.moonPhase,
      'temp': instance.temp,
      'feels_like': instance.feelsLike,
      'pressure': instance.pressure,
      'humidity': instance.humidity,
      'dew_point': instance.dewPoint,
      'wind_speed': instance.windSpeed,
      'wind_deg': instance.windDeg,
      'wind_gust': instance.windGust,
      'weather': instance.weathers,
      'clouds': instance.clouds,
      'pop': instance.pop,
      'rain': instance.rain,
      'uvi': instance.uvi,
    };
