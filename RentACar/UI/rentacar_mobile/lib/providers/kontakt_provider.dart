import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rentacar_admin/models/kontakt.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

class KontaktProvider extends BaseProvider<Kontakt> {
  static const String _baseUrl =
  String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:7005/");

  static const String _endpoint = "Kontakt";

  KontaktProvider() : super("Kontakt");

  @override
  Kontakt fromJson(data) {
    return Kontakt.fromJson(data);
  }

  @override
  Future<Kontakt> insert(dynamic request) async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Nepoznato!");
    }
  }
}
