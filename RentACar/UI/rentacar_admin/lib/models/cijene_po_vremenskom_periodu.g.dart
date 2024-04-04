// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cijene_po_vremenskom_periodu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CijenePoVremenskomPeriodu _$CijenePoVremenskomPerioduFromJson(
        Map<String, dynamic> json) =>
    CijenePoVremenskomPeriodu(
      json['cijenePoVremenskomPerioduId'] as int?,
      json['voziloId'] as int?,
      (json['cijena'] as num?)?.toDouble(),
      json['periodId'] as int?,
      json['vozilo'] == null
          ? null
          : Vozilo.fromJson(json['vozilo'] as Map<String, dynamic>),
      json['period'] == null
          ? null
          : Period.fromJson(json['period'] as Map<String, dynamic>),
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
