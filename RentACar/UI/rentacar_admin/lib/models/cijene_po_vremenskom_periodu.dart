import 'package:json_annotation/json_annotation.dart';
import 'package:rentacar_admin/models/period.dart';
import 'package:rentacar_admin/models/vozila.dart';

part 'cijene_po_vremenskom_periodu.g.dart';

@JsonSerializable()
class CijenePoVremenskomPeriodu {
  int? cijenePoVremenskomPerioduId;
  int? voziloId;
  int? periodId;
  double? cijena;
  Period? period;
  Vozilo? vozilo;

  CijenePoVremenskomPeriodu(this.cijenePoVremenskomPerioduId, this.voziloId,
      this.cijena, this.periodId, this.vozilo,this.period);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory CijenePoVremenskomPeriodu.fromJson(Map<String, dynamic> json) =>
      _$CijenePoVremenskomPerioduFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CijenePoVremenskomPerioduToJson(this);
}
