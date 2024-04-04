import 'package:json_annotation/json_annotation.dart';

part 'kontakt.g.dart';

@JsonSerializable()
class Kontakt {
  int? kontaktId;
  int? korisnikId;
  String? imePrezime;
  String? poruka;
  String? telefon;
  String? email;

  Kontakt(this.kontaktId, this.korisnikId, this.imePrezime, this.poruka,
      this.telefon, this.email);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Kontakt.fromJson(Map<String, dynamic> json) =>
      _$KontaktFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KontaktToJson(this);
}
