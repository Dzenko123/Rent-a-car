import 'package:json_annotation/json_annotation.dart';

part 'rezervacija_dodatna_usluga.g.dart';

@JsonSerializable()
class RezervacijaDodatnaUsluga {
  int? rezervacijaId;
  int? dodatnaUslugaId;

  RezervacijaDodatnaUsluga({
    this.rezervacijaId,
    this.dodatnaUslugaId,
  });
  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RezervacijaDodatnaUsluga.fromJson(Map<String, dynamic> json) =>
      _$RezervacijaDodatnaUslugaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RezervacijaDodatnaUslugaToJson(this);
}
