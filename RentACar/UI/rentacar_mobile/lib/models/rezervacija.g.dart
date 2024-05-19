// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rezervacija _$RezervacijaFromJson(Map<String, dynamic> json) => Rezervacija(
      json['rezervacijaId'] as int?,
      json['korisnikId'] as int?,
      json['voziloId'] as int?,
      json['gradId'] as int?,
      json['pocetniDatum'] == null
          ? null
          : DateTime.parse(json['pocetniDatum'] as String),
      json['zavrsniDatum'] == null
          ? null
          : DateTime.parse(json['zavrsniDatum'] as String),
      json['vozilo'] == null
          ? null
          : Vozilo.fromJson(json['vozilo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'korisnikId': instance.korisnikId,
      'voziloId': instance.voziloId,
      'gradId': instance.gradId,
      'pocetniDatum': instance.pocetniDatum?.toIso8601String(),
      'zavrsniDatum': instance.zavrsniDatum?.toIso8601String(),
      'vozilo': instance.vozilo,
    };
