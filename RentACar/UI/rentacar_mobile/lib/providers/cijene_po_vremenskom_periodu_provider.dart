import 'package:rentacar_admin/models/cijene_po_vremenskom_periodu.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CijenePoVremenskomPerioduProvider
    extends BaseProvider<CijenePoVremenskomPeriodu> {
  static const String _baseUrl =
      String.fromEnvironment("baseUrl", defaultValue: "https://10.0.2.2:7284/");

  static const String _endpoint = "CPVP";
  CijenePoVremenskomPerioduProvider() : super("CPVP");

  @override
  CijenePoVremenskomPeriodu fromJson(data) {
    // TODO: implement fromJson
    return CijenePoVremenskomPeriodu.fromJson(data);
  }

  Future<List<CijenePoVremenskomPeriodu>> getByVoziloId(int voziloId) async {
    try {
      final response = await http.get(
          Uri.parse('$_baseUrl$_endpoint/GetByVoziloId/$voziloId'),
          headers: createHeaders());
      if (response.statusCode == 200) {
        Iterable list = json.decode(response.body);
        return List<CijenePoVremenskomPeriodu>.from(
            list.map((model) => CijenePoVremenskomPeriodu.fromJson(model)));
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load data: $e');
    }
  }
}
