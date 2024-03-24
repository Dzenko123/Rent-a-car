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
      json['stateMachine'] as String?,
    );

Map<String, dynamic> _$VoziloToJson(Vozilo instance) => <String, dynamic>{
      'voziloId': instance.voziloId,
      'tipVozilaId': instance.tipVozilaId,
      'godinaProizvodnje': instance.godinaProizvodnje,
      'cijena': instance.cijena,
      'slika': instance.slika,
      'stateMachine': instance.stateMachine,
    };
