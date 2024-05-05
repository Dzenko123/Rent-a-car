// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vozilo_pregled.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoziloPregled _$VoziloPregledFromJson(Map<String, dynamic> json) =>
    VoziloPregled(
      voziloPregledId: json['voziloPregledId'] as int?,
      voziloId: json['voziloId'] as int?,
      datum: json['datum'] == null
          ? null
          : DateTime.parse(json['datum'] as String),
      vozilo: json['vozilo'] == null
          ? null
          : Vozilo.fromJson(json['vozilo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoziloPregledToJson(VoziloPregled instance) =>
    <String, dynamic>{
      'voziloPregledId': instance.voziloPregledId,
      'voziloId': instance.voziloId,
      'datum': instance.datum?.toIso8601String(),
      'vozilo': instance.vozilo,
    };
