// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vozila.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vozilo _$VoziloFromJson(Map<String, dynamic> json) => Vozilo(
      json['voziloId'] as int?,
      json['godinaProizvodnje'] as int?,
      (json['cijena'] as num?)?.toDouble(),
      json['tipVozilaId'] as int?,
      json['slika'] as String?,
      (json['kilometraza'] as num?)?.toDouble(),
      json['stateMachine'] as String?,
      json['gorivo'] as String?,
      json['marka'] as String?,
      json['model'] as String?,
      json['tipVozila'] == null
          ? null
          : TipVozila.fromJson(json['tipVozila'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoziloToJson(Vozilo instance) => <String, dynamic>{
      'voziloId': instance.voziloId,
      'tipVozilaId': instance.tipVozilaId,
      'godinaProizvodnje': instance.godinaProizvodnje,
      'cijena': instance.cijena,
      'kilometraza': instance.kilometraza,
      'slika': instance.slika,
      'stateMachine': instance.stateMachine,
      'gorivo': instance.gorivo,
      'model': instance.model,
      'marka': instance.marka,
      'tipVozila': instance.tipVozila,
    };
