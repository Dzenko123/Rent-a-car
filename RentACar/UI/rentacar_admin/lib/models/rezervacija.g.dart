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
      (json['totalPrice'] as num?)?.toDouble(),
      json['vozilo'] == null
          ? null
          : Vozilo.fromJson(json['vozilo'] as Map<String, dynamic>),
      (json['dodatnaUslugaId'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      json['zahtjev'] as bool?,
      (json['dodatnaUsluga'] as List<dynamic>?)
          ?.map((e) => DodatnaUsluga.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RezervacijaToJson(Rezervacija instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'korisnikId': instance.korisnikId,
      'voziloId': instance.voziloId,
      'gradId': instance.gradId,
      'pocetniDatum': instance.pocetniDatum?.toIso8601String(),
      'zavrsniDatum': instance.zavrsniDatum?.toIso8601String(),
      'totalPrice': instance.totalPrice,
      'zahtjev': instance.zahtjev,
      'vozilo': instance.vozilo,
      'dodatnaUslugaId': instance.dodatnaUslugaId,
      'dodatnaUsluga': instance.dodatnaUsluga,
    };
