import 'package:json_annotation/json_annotation.dart';

part 'tip_vozila.g.dart';

@JsonSerializable()
class TipVozila {
  int? tipVozilaId;
  String? tip;
  String? marka;
  String? model;

  TipVozila(this.tipVozilaId, this.tip, this.marka, this.model);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory TipVozila.fromJson(Map<String, dynamic> json) =>
      _$TipVozilaFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TipVozilaToJson(this);
}


// "id": 1,
//       "tip": "Limuzina",
//       "marka": "Mercedes-Benz",
//       "model": "E270"