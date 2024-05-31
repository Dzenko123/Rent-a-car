// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Period _$PeriodFromJson(Map<String, dynamic> json) => Period(
      (json['periodId'] as num?)?.toInt(),
      json['trajanje'] as String?,
    );

Map<String, dynamic> _$PeriodToJson(Period instance) => <String, dynamic>{
      'periodId': instance.periodId,
      'trajanje': instance.trajanje,
    };
