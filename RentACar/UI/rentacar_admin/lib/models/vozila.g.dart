// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vozila.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vozilo _$VoziloFromJson(Map<String, dynamic> json) => Vozilo(
      json['voziloId'] as int?,
      json['godinaProizvodnje'] as int?,
      (json['cijena'] as num?)?.toDouble(),
      json['dostupan'] as bool?,
      json['tipVozilaId'] as int?,
      json['stateMachine'] as String?,
      json['slika'] as String?,
    );

Map<String, dynamic> _$VoziloToJson(Vozilo instance) => <String, dynamic>{
      'voziloId': instance.voziloId,
      'tipVozilaId': instance.tipVozilaId,
      'godinaProizvodnje': instance.godinaProizvodnje,
      'cijena': instance.cijena,
      'dostupan': instance.dostupan,
      'stateMachine': instance.stateMachine,
      'slika': instance.slika,
    };
