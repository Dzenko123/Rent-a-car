// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uloge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uloge _$UlogeFromJson(Map<String, dynamic> json) => Uloge(
      ulogaId: json['ulogaId'] as int?,
      naziv: json['naziv'] as String?,
      opis: json['opis'] as String?,
    );

Map<String, dynamic> _$UlogeToJson(Uloge instance) => <String, dynamic>{
      'ulogaId': instance.ulogaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
    };
