import 'package:rentacar_admin/models/cijene_po_vremenskom_periodu.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class CijenePoVremenskomPerioduProvider extends BaseProvider<CijenePoVremenskomPeriodu> {
  static const String _baseUrl = String.fromEnvironment("baseUrl",
      defaultValue: "https://localhost:7284/");
  static const String _endpoint = "CPVP";
  CijenePoVremenskomPerioduProvider() : super("CPVP");

  @override
  CijenePoVremenskomPeriodu fromJson(data) {
    return CijenePoVremenskomPeriodu.fromJson(data);
  }

  Future<bool> deleteByVoziloId(int voziloId) async {
    var url = "$_baseUrl$_endpoint/DeleteByVoziloId/$voziloId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Greška prilikom brisanja!");
    }
  }
}

