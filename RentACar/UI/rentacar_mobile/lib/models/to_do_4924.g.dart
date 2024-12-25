// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'to_do_4924.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToDo4924Model _$ToDo4924ModelFromJson(Map<String, dynamic> json) =>
    ToDo4924Model(
      (json['toDo4924Id'] as num?)?.toInt(),
      json['nazivAktivnosti'] as String?,
      json['datumIzvrsenja'] == null
          ? null
          : DateTime.parse(json['datumIzvrsenja'] as String),
      json['status'] as String?,
      json['opisAktivnosti'] as String?,
      json['korisnik'] == null
          ? null
          : Korisnici.fromJson(json['korisnik'] as Map<String, dynamic>),
      (json['korisnikId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ToDo4924ModelToJson(ToDo4924Model instance) =>
    <String, dynamic>{
      'toDo4924Id': instance.toDo4924Id,
      'nazivAktivnosti': instance.nazivAktivnosti,
      'opisAktivnosti': instance.opisAktivnosti,
      'datumIzvrsenja': instance.datumIzvrsenja?.toIso8601String(),
      'status': instance.status,
      'korisnikId': instance.korisnikId,
      'korisnik': instance.korisnik,
    };
