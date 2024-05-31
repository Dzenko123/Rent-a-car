// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rezervacija_dodatna_usluga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RezervacijaDodatnaUsluga _$RezervacijaDodatnaUslugaFromJson(
        Map<String, dynamic> json) =>
    RezervacijaDodatnaUsluga(
      rezervacijaId: (json['rezervacijaId'] as num?)?.toInt(),
      dodatnaUslugaId: (json['dodatnaUslugaId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RezervacijaDodatnaUslugaToJson(
        RezervacijaDodatnaUsluga instance) =>
    <String, dynamic>{
      'rezervacijaId': instance.rezervacijaId,
      'dodatnaUslugaId': instance.dodatnaUslugaId,
    };
