import 'package:json_annotation/json_annotation.dart';
import 'package:rentacar_admin/models/vozila.dart';
part 'vozilo_pregled.g.dart';

@JsonSerializable()
class VoziloPregled {
  int? voziloPregledId;
  int? voziloId;
  DateTime? datum;
  Vozilo? vozilo;

  VoziloPregled({this.voziloPregledId, this.voziloId, this.datum, this.vozilo});

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory VoziloPregled.fromJson(Map<String, dynamic> json) =>
      _$VoziloPregledFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$VoziloPregledToJson(this);
}
