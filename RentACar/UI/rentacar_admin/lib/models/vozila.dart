import 'package:json_annotation/json_annotation.dart';

/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'vozila.g.dart';

@JsonSerializable()
class Vozilo {
  int? voziloId;
  int? tipVozilaId;
  int? godinaProizvodnje;
  double? cijena;
  bool? dostupan;
  String? slika;
  double? kilometraza;
  String? stateMachine;

  Vozilo(this.voziloId, this.godinaProizvodnje, this.cijena, this.tipVozilaId,
      this.slika, this.stateMachine, this.dostupan, this.kilometraza);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Vozilo.fromJson(Map<String, dynamic> json) => _$VoziloFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$VoziloToJson(this);
}

    // {
    //   "voziloId": 1,
    //   "tipVozilaId": 1,
    //   "slika": "",
    //   "dostupan": true,
    //   "cijena": 9,
    //   "godinaProizvodnje": 2005,
    //   "stateMachine": "draft"
    // }