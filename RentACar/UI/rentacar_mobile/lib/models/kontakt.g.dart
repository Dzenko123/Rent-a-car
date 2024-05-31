// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kontakt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kontakt _$KontaktFromJson(Map<String, dynamic> json) => Kontakt(
      (json['kontaktId'] as num?)?.toInt(),
      (json['korisnikId'] as num?)?.toInt(),
      json['imePrezime'] as String?,
      json['poruka'] as String?,
      json['telefon'] as String?,
      json['email'] as String?,
    );

Map<String, dynamic> _$KontaktToJson(Kontakt instance) => <String, dynamic>{
      'kontaktId': instance.kontaktId,
      'korisnikId': instance.korisnikId,
      'imePrezime': instance.imePrezime,
      'poruka': instance.poruka,
      'telefon': instance.telefon,
      'email': instance.email,
    };
