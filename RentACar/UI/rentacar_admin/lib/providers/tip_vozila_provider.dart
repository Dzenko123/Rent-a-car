import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/base_provider.dart';
import 'package:rentacar_admin/utils/util.dart';

class TipVozilaProvider extends BaseProvider<TipVozila> {
  TipVozilaProvider() : super("TipVozila");

  @override
  TipVozila fromJson(data) {
    // TODO: implement fromJson
    return TipVozila.fromJson(data);
  }
}
