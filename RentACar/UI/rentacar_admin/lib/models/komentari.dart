import 'package:json_annotation/json_annotation.dart';
part 'komentari.g.dart';

@JsonSerializable()
class Komentari {
  int? komentarId;
  int? korisnikId;
  int? voziloId;
  String? komentar;

  Komentari(this.komentarId, this.korisnikId, this.voziloId, this.komentar);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Komentari.fromJson(Map<String, dynamic> json) =>
      _$KomentariFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$KomentariToJson(this);
}
