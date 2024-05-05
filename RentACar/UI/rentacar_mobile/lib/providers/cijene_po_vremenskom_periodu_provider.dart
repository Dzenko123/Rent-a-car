import 'package:rentacar_admin/models/cijene_po_vremenskom_periodu.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class CijenePoVremenskomPerioduProvider extends BaseProvider<CijenePoVremenskomPeriodu> {
  CijenePoVremenskomPerioduProvider() : super("CPVP");

  @override
   CijenePoVremenskomPeriodu fromJson(data) {
    // TODO: implement fromJson
    return  CijenePoVremenskomPeriodu.fromJson(data);
  }
}
