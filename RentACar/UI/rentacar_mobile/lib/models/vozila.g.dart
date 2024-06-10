// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vozila.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vozilo _$VoziloFromJson(Map<String, dynamic> json) => Vozilo(
      (json['voziloId'] as num?)?.toInt(),
      (json['godinaProizvodnje'] as num?)?.toInt(),
      (json['tipVozilaId'] as num?)?.toInt(),
      (json['gorivoId'] as num?)?.toInt(),
      json['slika'] as String?,
      (json['kilometraza'] as num?)?.toDouble(),
      json['stateMachine'] as String?,
      json['gorivo'] == null
          ? null
          : Gorivo.fromJson(json['gorivo'] as Map<String, dynamic>),
      json['marka'] as String?,
      json['motor'] as String?,
      json['model'] as String?,
      json['tipVozila'] == null
          ? null
          : TipVozila.fromJson(json['tipVozila'] as Map<String, dynamic>),
      (json['komentari'] as List<dynamic>?)
          ?.map((e) => Komentari.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$VoziloToJson(Vozilo instance) => <String, dynamic>{
      'voziloId': instance.voziloId,
      'tipVozilaId': instance.tipVozilaId,
      'gorivoId': instance.gorivoId,
      'godinaProizvodnje': instance.godinaProizvodnje,
      'kilometraza': instance.kilometraza,
      'slika': instance.slika,
      'stateMachine': instance.stateMachine,
      'model': instance.model,
      'marka': instance.marka,
      'motor': instance.motor,
      'tipVozila': instance.tipVozila,
      'gorivo': instance.gorivo,
      'komentari': instance.komentari,
    };
