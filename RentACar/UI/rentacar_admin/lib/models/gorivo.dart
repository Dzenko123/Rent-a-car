import 'package:json_annotation/json_annotation.dart';

part 'gorivo.g.dart';

@JsonSerializable()
class Gorivo {
  int gorivoId;
  String? tip;

  Gorivo(this.gorivoId, this.tip);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Gorivo.fromJson(Map<String, dynamic> json) =>
      _$GorivoFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GorivoToJson(this);
}
