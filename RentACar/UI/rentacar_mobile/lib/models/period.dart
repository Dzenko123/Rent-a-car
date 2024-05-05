import 'package:json_annotation/json_annotation.dart';
part 'period.g.dart';

@JsonSerializable()
class Period {
  int? periodId;
  String? trajanje;

  Period(this.periodId, this.trajanje);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PeriodToJson(this);
  Period toLowerCase() {
    return Period(periodId, trajanje?.toLowerCase());
  }
}
