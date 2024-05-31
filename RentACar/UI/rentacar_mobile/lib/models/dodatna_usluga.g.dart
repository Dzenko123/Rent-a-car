// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dodatna_usluga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DodatnaUsluga _$DodatnaUslugaFromJson(Map<String, dynamic> json) =>
    DodatnaUsluga(
      dodatnaUslugaId: (json['dodatnaUslugaId'] as num?)?.toInt(),
      naziv: json['naziv'] as String?,
      cijena: (json['cijena'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DodatnaUslugaToJson(DodatnaUsluga instance) =>
    <String, dynamic>{
      'dodatnaUslugaId': instance.dodatnaUslugaId,
      'naziv': instance.naziv,
      'cijena': instance.cijena,
    };
