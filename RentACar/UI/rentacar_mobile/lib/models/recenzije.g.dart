// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzije.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recenzije _$RecenzijeFromJson(Map<String, dynamic> json) => Recenzije(
      json['recenzijaId'] as int?,
      json['korisnikId'] as int?,
      json['voziloId'] as int?,
      json['isLiked'] as bool?,
      json['komentar'] as String?,
    );

Map<String, dynamic> _$RecenzijeToJson(Recenzije instance) => <String, dynamic>{
      'recenzijaId': instance.recenzijaId,
      'korisnikId': instance.korisnikId,
      'voziloId': instance.voziloId,
      'isLiked': instance.isLiked,
      'komentar': instance.komentar,
    };
