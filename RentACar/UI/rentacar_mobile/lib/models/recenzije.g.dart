// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recenzije.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Recenzije _$RecenzijeFromJson(Map<String, dynamic> json) => Recenzije(
      recenzijaId: (json['recenzijaId'] as num?)?.toInt(),
      korisnikId: (json['korisnikId'] as num?)?.toInt(),
      voziloId: (json['voziloId'] as num?)?.toInt(),
      isLiked: json['isLiked'] as bool?,
    );

Map<String, dynamic> _$RecenzijeToJson(Recenzije instance) => <String, dynamic>{
      'recenzijaId': instance.recenzijaId,
      'korisnikId': instance.korisnikId,
      'voziloId': instance.voziloId,
      'isLiked': instance.isLiked,
    };
