import 'package:rentacar_admin/models/period.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class PeriodProvider extends BaseProvider<Period> {
  PeriodProvider() : super("Period");

  @override
  Period fromJson(data) {
    // TODO: implement fromJson
    return Period.fromJson(data);
  }
}
