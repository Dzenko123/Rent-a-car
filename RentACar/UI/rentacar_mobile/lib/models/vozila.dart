import 'package:json_annotation/json_annotation.dart';
import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/models/komentari.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'vozila.g.dart';

@JsonSerializable()
class Vozilo {
  int? voziloId;
  int? tipVozilaId;
  int? gorivoId;
  int? godinaProizvodnje;
  double? kilometraza;
  String? slika;
  String? stateMachine;
  String? model;
  String? marka;
  String? motor;
  TipVozila? tipVozila;
  Gorivo? gorivo;
  List<Komentari>? komentari;

  Vozilo(
    this.voziloId,
    this.godinaProizvodnje,
    this.tipVozilaId,
    this.gorivoId,
    this.slika,
    this.kilometraza,
    this.stateMachine,
    this.gorivo,
    this.marka,
    this.motor,
    this.model,
    this.tipVozila,
    this.komentari,
  );

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Vozilo.fromJson(Map<String, dynamic> json) => _$VoziloFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$VoziloToJson(this);
}
