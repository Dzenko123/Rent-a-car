// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'komentari.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Komentari _$KomentariFromJson(Map<String, dynamic> json) => Komentari(
      (json['komentarId'] as num?)?.toInt(),
      (json['korisnikId'] as num?)?.toInt(),
      (json['voziloId'] as num?)?.toInt(),
      json['komentar'] as String?,
    );

Map<String, dynamic> _$KomentariToJson(Komentari instance) => <String, dynamic>{
      'komentarId': instance.komentarId,
      'korisnikId': instance.korisnikId,
      'voziloId': instance.voziloId,
      'komentar': instance.komentar,
    };
