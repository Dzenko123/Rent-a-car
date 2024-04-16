import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
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
        child: Column(children: [_buildSearch(), _buildDataListView()]),
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
                labelText: "pretraga:",
                labelStyle: TextStyle(color: Colors.black),
              ),
              controller: _ftsController,
              style: TextStyle(color: Colors.black),
            ),
          ),
          SizedBox(width: 8),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                print("Pretraga uspješna");
                await initForm();
                setState(() {});
              },
              child: const Text("Pretraga"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
            child: DataTable(
                columns: [
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Rezervacija ID',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Korisnik ID',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),const DataColumn(
            label: Expanded(
              child: Text(
                'Korisničko ime',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Vozilo ID',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Vozilo model',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Pocetni datum',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Zavrsni datum',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          
        ],
                rows: rezervacijaResult?.result
                        .map(
                          (Rezervacija r) => DataRow(
                            onSelectChanged: (selected) =>
                                {if (selected == true) {}},
                            cells: [
                              DataCell(Text(r.rezervacijaId?.toString() ?? "")),
                              DataCell(Text(r.korisnikId?.toString() ?? "")),
                               DataCell(
                                FutureBuilder(
                                  future: _getKorisnickoIme(r.korisnikId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    return Text(snapshot.data.toString() ?? '');
                                  },
                                ),
                              ),
                              DataCell(Text(r.voziloId?.toString() ?? "")),
                              DataCell(
                                FutureBuilder(
                                  future: _getVozilo(r.voziloId),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return CircularProgressIndicator();
                                    }
                                    if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    }
                                    return Text(snapshot.data.toString() ?? '');
                                  },
                                ),
                              ),
                              DataCell(Text(r.pocetniDatum?.toString() ?? "")),
                              DataCell(Text(r.zavrsniDatum?.toString() ?? "")),
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
