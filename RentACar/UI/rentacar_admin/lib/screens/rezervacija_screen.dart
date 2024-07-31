import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/rezervacija_dodatna_usluga.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/grad_dodatneUsluge_screen.dart';
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
  SearchResult<Grad>? gradResult;
  SearchResult<DodatnaUsluga>? dodatnaUslugaResult;
  SearchResult<RezervacijaDodatnaUsluga>? rezervacijaDodatnaUslugaResult;
  late RezervacijaProvider _rezervacijaProvider;
  late KorisniciProvider _korisniciProvider;
  late VozilaProvider _vozilaProvider;
  late GradProvider _gradProvider;
  late DodatnaUslugaProvider _dodatnaUslugaProvider;
  late RezervacijaDodatnaUslugaProvider _rezervacijaDodatnaUslugaProvider;
  bool isLoading = true;
  final TextEditingController _ftsController = TextEditingController();
  final TextEditingController _vehicleModelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _rezervacijaProvider = RezervacijaProvider();
    _korisniciProvider = KorisniciProvider();
    _vozilaProvider = VozilaProvider();
    _gradProvider = GradProvider();
    _dodatnaUslugaProvider = DodatnaUslugaProvider();
    _rezervacijaDodatnaUslugaProvider = RezervacijaDodatnaUslugaProvider();
    initForm();
  }

  Future<void> initForm() async {
    rezervacijaResult = await _rezervacijaProvider.get();
    korisniciResult = await _korisniciProvider.get();
    vozilaResult = await _vozilaProvider.get();
    gradResult = await _gradProvider.get();
    dodatnaUslugaResult = await _dodatnaUslugaProvider.get();
    rezervacijaDodatnaUslugaResult =
        await _rezervacijaDodatnaUslugaProvider.get();
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
            child: TextField(
              decoration: const InputDecoration(
                labelText: "Model vozila pretraga:",
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _vehicleModelController,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                await initForm();
                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
              ),
              child: const Text("Pretraga"),
            ),
          ),
          SizedBox(
            width: 30,
          ),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => GradDodatneUslugeScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
              ),
              child: const Text("Upravljaj gradovima i dodatnim uslugama"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView(SearchResult<Vozilo>? vozilaResult) {
    List<Rezervacija> filteredResults = rezervacijaResult?.result.where((k) {
          String korisnickoIme = korisniciResult?.result
                  .firstWhere((korisnik) => korisnik.korisnikId == k.korisnikId,
                      orElse: () => Korisnici.fromJson({}))
                  .korisnickoIme
                  ?.toLowerCase() ??
              '';
          String voziloModel = vozilaResult?.result
                  .firstWhere((vozilo) => vozilo.voziloId == k.voziloId,
                      orElse: () => Vozilo.fromJson({}))
                  .model
                  ?.toLowerCase() ??
              '';
          return korisnickoIme.contains(_ftsController.text.toLowerCase()) &&
              voziloModel.contains(_vehicleModelController.text.toLowerCase());
        }).toList() ??
        [];
    return Expanded(
        child: SingleChildScrollView(
            child: DataTable(
                columnSpacing: 30.0,
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
                      child: Center(
                        child: Text(
                          'Korisnik',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                      label: Expanded(
                          child: Center(
                    child: Text(
                      'Vozilo (model)',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.red),
                    ),
                  ))),
                  DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          'Slika',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                      label: Expanded(
                          child: Center(
                    child: Text(
                      'Početni datum',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.white),
                    ),
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Center(
                    child: Text(
                      'Završni datum',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.white),
                    ),
                  ))),
                  DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          'Dodatne usluge',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          'Grad',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          'Cijena (u KM)',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Center(
                        child: Text(
                          'Zahtjev za otkazivanje',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
                rows: filteredResults
                        .map(
                          (Rezervacija r) => DataRow(
                            cells: [
                              DataCell(
                                Center(
                                  child: FutureBuilder(
                                    future: _getKorisnickoIme(r.korisnikId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      return Text(
                                          snapshot.data.toString() ?? '',
                                          style: const TextStyle(
                                              color: Colors.white));
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: FutureBuilder(
                                    future: _getVozilo(r.voziloId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      return Text(
                                          snapshot.data.toString() ?? '',
                                          style: const TextStyle(
                                              color: Colors.white));
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: SizedBox(
                                    width: 75,
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
                                                    vozilo.voziloId ==
                                                    r.voziloId)
                                                .slika!),
                                            height: 180,
                                            fit: BoxFit.contain,
                                          )
                                        : SizedBox.shrink(),
                                  ),
                                ),
                              ),
                              DataCell(Center(
                                child: Text(formatDateTime(r.pocetniDatum),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              )),
                              DataCell(Center(
                                child: Text(formatDateTime(r.zavrsniDatum),
                                    style:
                                        const TextStyle(color: Colors.white)),
                              )),
                              DataCell(
                                Center(
                                  child: FutureBuilder(
                                    future: _getDodatneUsluge(r.rezervacijaId!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      List<DodatnaUsluga> dodatneUsluge =
                                          snapshot.data ?? [];
                                      if (dodatneUsluge.isEmpty) {
                                        return Text('/',
                                            style: const TextStyle(
                                                color: Colors.white));
                                      } else if (dodatneUsluge.length == 1) {
                                        return Text(
                                            dodatneUsluge.first.naziv ?? '',
                                            style: const TextStyle(
                                                color: Colors.white));
                                      } else {
                                        return Tooltip(
                                          message: 'Prikaži dodatne usluge',
                                          child: IconButton(
                                            icon: Icon(Icons.info_outline,
                                                color: Colors.blue),
                                            onPressed: () {
                                              _showDodatneUslugeDialog(
                                                  dodatneUsluge);
                                            },
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: FutureBuilder(
                                    future: _getDodatniGradovi(r.gradId!),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      }
                                      Grad dodatniGrad = snapshot.data as Grad;
                                      return Text(dodatniGrad.naziv ?? '',
                                          style: const TextStyle(
                                              color: Colors.white));
                                    },
                                  ),
                                ),
                              ),
                              DataCell(Center(
                                child: Text(r.totalPrice?.toString() ?? "",
                                    style:
                                        const TextStyle(color: Colors.white)),
                              )),
                              DataCell(
                                Align(
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        r.zahtjev != null && r.zahtjev!
                                            ? 'Na čekanju'
                                            : '/',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      const SizedBox(width: 5),
                                      if (r.zahtjev == true)
                                        Flexible(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              try {
                                                bool success =
                                                    await _rezervacijaProvider
                                                        .potvrdiOtkazivanje(
                                                            r.rezervacijaId!);
                                                if (success) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Rezervacija uklonjena!'),
                                                        backgroundColor:
                                                            Colors.green),
                                                  );
                                                  await initForm();
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content:
                                                            Text('Greška')),
                                                  );
                                                }
                                              } catch (e) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                      content: Text('Greška')),
                                                );
                                                print(
                                                    "Error confirming cancellation: $e");
                                              }
                                            },
                                            child: Text("Potvrdi"),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
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

  Future<List<DodatnaUsluga>> _getDodatneUsluge(int rezervacijaId) async {
    if (rezervacijaId == null || dodatnaUslugaResult == null) return [];

    List<int?>? dodatneUslugeIds = rezervacijaDodatnaUslugaResult?.result
        .where((element) => element.rezervacijaId == rezervacijaId)
        .map((e) => e.dodatnaUslugaId)
        .toList();

    List<DodatnaUsluga> dodatneUsluge = [];
    if (dodatneUslugeIds != null) {
      for (var id in dodatneUslugeIds) {
        var usluga = dodatnaUslugaResult!.result.firstWhere(
            (element) => element.dodatnaUslugaId == id,
            orElse: () => DodatnaUsluga());
        dodatneUsluge.add(usluga);
      }
    }

    return dodatneUsluge;
  }

  Future<Grad> _getDodatniGradovi(int gradId) async {
    if (gradId == null || gradResult == null) return Grad(null, '');

    var grad = gradResult!.result.firstWhere(
        (element) => element.gradId == gradId,
        orElse: () => Grad(null, ''));
    return grad;
  }

  void _showDodatneUslugeDialog(List<DodatnaUsluga> dodatneUsluge) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dodatne usluge'),
          content: SingleChildScrollView(
            child: ListBody(
              children: dodatneUsluge
                  .map((usluga) => Text(usluga.naziv ?? ''))
                  .toList(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Zatvori'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
