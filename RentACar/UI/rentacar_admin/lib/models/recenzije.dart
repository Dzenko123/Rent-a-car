import 'package:json_annotation/json_annotation.dart';
part 'recenzije.g.dart';

@JsonSerializable()
class Recenzije {
  int? recenzijaId;
  int? korisnikId;
  int? voziloId;
  bool? isLiked;

  Recenzije({this.recenzijaId, required this.korisnikId, required this.voziloId, required this.isLiked});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Recenzije.fromJson(Map<String, dynamic> json) =>
      _$RecenzijeFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RecenzijeToJson(this);
}
