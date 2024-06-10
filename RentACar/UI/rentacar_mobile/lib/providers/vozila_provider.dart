import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/base_provider.dart';

import '../models/search_result.dart';

class VozilaProvider extends BaseProvider<Vozilo> {
  static const String _baseUrl =
      String.fromEnvironment("baseUrl", defaultValue: "http://10.0.2.2:7284/");

  static const String _endpoint = "Vozila";

  VozilaProvider() : super(_endpoint);

  @override
  Vozilo fromJson(data) {
    return Vozilo.fromJson(data);
  }

  Future<Vozilo?> getByVoziloId(int id) async {
    try {
      String url = '$_baseUrl$_endpoint/$id';
      var response = await http.get(Uri.parse(url), headers: createHeaders());
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return fromJson(jsonData);
      } else {
        throw Exception('Failed to load vozilo');
      }
    } catch (e) {
      print('Error fetching vozilo by ID: $e');
      return null;
    }
  }


  Future<SearchResult<Vozilo>> getActiveVehicles({dynamic filter}) async {
    var url = '$_baseUrl$_endpoint/active';

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }
    final headers = createHeaders();
    final uri = Uri.parse(url);
    final response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);

      var result = SearchResult<Vozilo>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw Exception("Failed to fetch active vehicles.");
    }
  }


  Future<Vozilo> activate(int id) async {
    final url = '$_baseUrl$_endpoint/$id/activate';
    final headers = createHeaders();
    var uri = Uri.parse(url);

    final response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Aktivacija nije uspjela.");
    }
  }

  @override
  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else if (response.statusCode == 500) {
      throw Exception(
          "Došlo je do greške u spremanju podataka! (status:${response.statusCode})");
    } else {
      throw Exception(
          "Vozilo nije aktivno! (status:${response.statusCode})");
    }
  }

  Future<Vozilo> hide(int id) async {
    final url = '$_baseUrl$_endpoint/$id/hide';
    final headers = createHeaders();
    var uri = Uri.parse(url);

    final response = await http.put(uri, headers: headers);

    if (isValidResponse(response)) {
      final data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Skrivanje nije uspjelo.");
    }
  }


  @override
  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  } Future<Vozilo> getById(int id) async {
    var url = "$_baseUrl$_endpoint/$id/active";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unexpected error occurred while fetching user data");
    }
  }
}
