// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'komentari.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Komentari _$KomentariFromJson(Map<String, dynamic> json) => Komentari(
      json['komentarId'] as int?,
      json['korisnikId'] as int?,
      json['voziloId'] as int?,
      json['komentar'] as String?,
    );

Map<String, dynamic> _$KomentariToJson(Komentari instance) => <String, dynamic>{
      'komentarId': instance.komentarId,
      'korisnikId': instance.korisnikId,
      'voziloId': instance.voziloId,
      'komentar': instance.komentar,
    };
