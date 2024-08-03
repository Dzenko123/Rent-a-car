import 'package:rentacar_admin/models/period.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PeriodProvider extends BaseProvider<Period> {
  static const String _baseUrl =
      String.fromEnvironment("baseUrl", defaultValue: "https://10.0.2.2:7284/");
  static const String _endpoint = "Period";
  PeriodProvider() : super("Period");

  @override
  Period fromJson(data) {
    // TODO: implement fromJson
    return Period.fromJson(data);
  }

  Future<void> deletePeriod(int periodId) async {
    await delete(periodId);
  }

  Future<List<Period>> getAll() async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return List<Period>.from(data.map((item) => Period.fromJson(item)));
    } else {
      throw Exception("Nepoznato!");
    }
  }

  Future<List<Period>> getAllLowerCase() async {
    var goriva = await getAll();
    return goriva.map((gorivo) => gorivo.toLowerCase()).toList();
  }
}
