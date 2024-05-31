// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cijene_po_vremenskom_periodu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CijenePoVremenskomPeriodu _$CijenePoVremenskomPerioduFromJson(
        Map<String, dynamic> json) =>
    CijenePoVremenskomPeriodu(
      cijenePoVremenskomPerioduId:
          (json['cijenePoVremenskomPerioduId'] as num?)?.toInt(),
      voziloId: (json['voziloId'] as num?)?.toInt(),
      periodId: (json['periodId'] as num?)?.toInt(),
      cijena: (json['cijena'] as num?)?.toDouble(),
      period: json['period'] == null
          ? null
          : Period.fromJson(json['period'] as Map<String, dynamic>),
      vozilo: json['vozilo'] == null
          ? null
          : Vozilo.fromJson(json['vozilo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CijenePoVremenskomPerioduToJson(
        CijenePoVremenskomPeriodu instance) =>
    <String, dynamic>{
      'cijenePoVremenskomPerioduId': instance.cijenePoVremenskomPerioduId,
      'voziloId': instance.voziloId,
      'periodId': instance.periodId,
      'cijena': instance.cijena,
      'period': instance.period,
      'vozilo': instance.vozilo,
    };
