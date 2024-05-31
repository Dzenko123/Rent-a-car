// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tip_vozila.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TipVozila _$TipVozilaFromJson(Map<String, dynamic> json) => TipVozila(
      (json['tipVozilaId'] as num?)?.toInt(),
      json['tip'] as String?,
      json['opis'] as String?,
    );

Map<String, dynamic> _$TipVozilaToJson(TipVozila instance) => <String, dynamic>{
      'tipVozilaId': instance.tipVozilaId,
      'tip': instance.tip,
      'opis': instance.opis,
    };
