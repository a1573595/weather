// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feels_like.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeelsLike _$FeelsLikeFromJson(Map<String, dynamic> json) => FeelsLike(
      (json['day'] as num).toDouble(),
      (json['night'] as num).toDouble(),
      (json['even'] as num?)?.toDouble(),
      (json['morn'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FeelsLikeToJson(FeelsLike instance) => <String, dynamic>{
      'day': instance.day,
      'night': instance.night,
      'even': instance.even,
      'morn': instance.morn,
    };
