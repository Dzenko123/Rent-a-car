// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vozila.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vozilo _$VoziloFromJson(Map<String, dynamic> json) => Vozilo(
      json['voziloId'] as int?,
      json['godinaProizvodnje'] as int?,
      json['motor'] as String?,
      json['tipVozilaId'] as int?,
      json['gorivoId'] as int?,
      json['slika'] as String?,
      (json['kilometraza'] as num?)?.toDouble(),
      json['stateMachine'] as String?,
      json['gorivo'] == null
          ? null
          : Gorivo.fromJson(json['gorivo'] as Map<String, dynamic>),
      json['marka'] as String?,
      json['model'] as String?,
      json['tipVozila'] == null
          ? null
          : TipVozila.fromJson(json['tipVozila'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VoziloToJson(Vozilo instance) => <String, dynamic>{
      'voziloId': instance.voziloId,
      'tipVozilaId': instance.tipVozilaId,
      'gorivoId': instance.gorivoId,
      'godinaProizvodnje': instance.godinaProizvodnje,
      'motor': instance.motor,
      'kilometraza': instance.kilometraza,
      'slika': instance.slika,
      'stateMachine': instance.stateMachine,
      'model': instance.model,
      'marka': instance.marka,
      'tipVozila': instance.tipVozila,
      'gorivo': instance.gorivo,
    };
