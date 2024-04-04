import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/uloge.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'package:rentacar_admin/utils/util.dart';

class KorisniciProvider extends BaseProvider<Korisnici> {
  KorisniciProvider() : super("Korisnici");

  @override
  Korisnici fromJson(data) {
    var korisnik = Korisnici.fromJson(data);
    if (data['korisniciUloge'] != null) {
      korisnik.uloge = List<Uloge>.from(
          data['korisniciUloge'].map((x) => Uloge.fromJson(x['uloga'])));
    }
    return korisnik;
  }
}
