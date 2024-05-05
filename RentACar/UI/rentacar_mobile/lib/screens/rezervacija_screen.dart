import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class RezervacijaScreen extends StatefulWidget {
  Rezervacija? rezervacija;
  RezervacijaScreen({super.key});

  @override
  State<RezervacijaScreen> createState() => _RezervacijaScreenState();
}

class _RezervacijaScreenState extends State<RezervacijaScreen> {
  SearchResult<Rezervacija>? rezervacijaResult;
  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Vozilo>? vozilaResult;

  late RezervacijaProvider _rezervacijaProvider;
  late KorisniciProvider _korisniciProvider;
  late VozilaProvider _vozilaProvider;
  bool isLoading = true;
  final TextEditingController _ftsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rezervacijaProvider = RezervacijaProvider();
    _korisniciProvider = KorisniciProvider();
    _vozilaProvider = VozilaProvider();
    initForm();
  }

  Future<void> initForm() async {
    rezervacijaResult = await _rezervacijaProvider.get();
    korisniciResult = await _korisniciProvider.get();
    vozilaResult = await _vozilaProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Rezervacije"),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color.fromARGB(255, 68, 68, 68),
              Color.fromARGB(255, 148, 147, 147),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(children: [
          _buildSearch(),
          const SizedBox(height: 20),
          _buildDataListView(vozilaResult)
        ]),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Korisnicko ime pretraga:",
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _ftsController,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                print("Pretraga uspješna");
                await initForm();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
              ),
              child: const Text("Pretraga"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView(SearchResult<Vozilo>? vozilaResult) {
    List<Rezervacija> filteredResults = rezervacijaResult?.result
            .where((k) =>
                k.korisnikId != null &&
                korisniciResult!.result
                    .firstWhere(
                        (korisnik) => korisnik.korisnikId == k.korisnikId,
                        orElse: () => Korisnici.fromJson({}))
                    .korisnickoIme!
                    .toLowerCase()
                    .contains(_ftsController.text.toLowerCase()))
            .toList() ??
        [];
    return Expanded(
        child: SingleChildScrollView(
            child: DataTable(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF000000),
                      Color.fromARGB(255, 54, 54, 54),
                      Color.fromARGB(255, 82, 81, 81),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(15.0),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                columns: const [
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Rezervacija ID',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Korisnik ID',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Korisničko ime',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.red),
                      ),
                    ),
                  ),
                  
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Vozilo model',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.red),
                  ))),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Slika',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Pocetni datum',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Zavrsni datum',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                ],
                rows: filteredResults
                        .map(
                          (Rezervacija r) => DataRow(
                            // onSelectChanged: (selected) =>
                            //     {if (selected == true) {}},
                            cells: [
                              DataCell(Text(r.rezervacijaId?.toString() ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(r.korisnikId?.toString() ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(
                                FutureBuilder(
                                  future: _getKorisnickoIme(r.korisnikId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    return Text(snapshot.data.toString() ?? '',
                                        style: const TextStyle(
                                            color: Colors.white));
                                  },
                                ),
                              ),
                              
                              DataCell(
                                FutureBuilder(
                                  future: _getVozilo(r.voziloId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    return Text(snapshot.data.toString() ?? '',
                                        style: const TextStyle(
                                            color: Colors.white));
                                  },
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 80,
                                 
                                  child: vozilaResult?.result
                                              .firstWhere(
                                                  (vozilo) =>
                                                      vozilo.voziloId ==
                                                      r.voziloId,
                                                  orElse: () =>
                                                      Vozilo.fromJson({}))
                                              .slika !=
                                          null
                                      ? Image.memory(
                                          base64Decode(vozilaResult!.result
                                              .firstWhere((vozilo) =>
                                                  vozilo.voziloId == r.voziloId)
                                              .slika!),height: 180,
                                          fit: BoxFit.contain,
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ),
                              DataCell(Text(formatDateTime(r.pocetniDatum),
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(formatDateTime(r.zavrsniDatum),
                                  style: const TextStyle(color: Colors.white))),
                            ],
                          ),
                        )
                        .toList() ??
                    [])));
  }

  Future<String?> _getKorisnickoIme(int? korisnikId) async {
    if (korisnikId == null || korisniciResult == null) return null;

    var korisnik = korisniciResult!.result.firstWhere(
      (korisnik) => korisnik.korisnikId == korisnikId,
      orElse: () => Korisnici.fromJson({}),
    );

    return korisnik.korisnickoIme;
  }

  Future<String?> _getVozilo(int? voziloId) async {
    if (voziloId == null || vozilaResult == null) return null;

    var vozilo = vozilaResult!.result.firstWhere(
      (vozilo) => vozilo.voziloId == voziloId,
      orElse: () => Vozilo.fromJson({}),
    );

    return vozilo.model;
  }
}
