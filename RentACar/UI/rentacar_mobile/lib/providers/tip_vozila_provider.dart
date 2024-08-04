import 'dart:convert';

import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class TipVozilaProvider extends BaseProvider<TipVozila> {
  static const String _baseUrl =
  String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:7284/");
  static const String _endpoint = "TipVozila";

  TipVozilaProvider() : super("TipVozila");

  @override
  TipVozila fromJson(data) {
    // TODO: implement fromJson
    return TipVozila.fromJson(data);
  }

  Future<TipVozila?> getById(int id) async {
    try {
      String url = '$_baseUrl$_endpoint/$id';
      var response = await http.get(Uri.parse(url), headers: createHeaders());
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData);
      } else {
        throw Exception('Failed to load tip vozila');
      }
    } catch (e) {
      print('Error fetching tip vozila by ID: $e');
      return null;
    }
  }
}
