import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/kontakt.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/providers/kontakt_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class KontaktScreen extends StatefulWidget {
  Kontakt? kontakt;
  KontaktScreen({super.key});

  @override
  State<KontaktScreen> createState() => _KontaktScreenState();
}

class _KontaktScreenState extends State<KontaktScreen> {
  SearchResult<Kontakt>? kontaktResult;
  SearchResult<Korisnici>? korisniciResult;

  late KontaktProvider _kontaktProvider;
  late KorisniciProvider _korisniciProvider;
  bool isLoading = true;
  final TextEditingController _ftsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _kontaktProvider = KontaktProvider();
    _korisniciProvider = KorisniciProvider();
    initForm();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Kontakt list"),
      child: Container(
        child: Column(children: [_buildSearch(), _buildDataListView()]),
      ),
    );
  }

  Future<void> initForm() async {
    kontaktResult = await _kontaktProvider.get();
    korisniciResult = await _korisniciProvider.get();
    var data = await _kontaktProvider.get(filter: {'fts': _ftsController.text});
    setState(() {
      kontaktResult = data;
      isLoading = false;
    });
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
    List<Kontakt> filteredResults = kontaktResult?.result
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
                columns: [
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Kontakt ID',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Korisnik ID',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
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
            'Ime i prezime',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Poruka',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Telefon',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Email',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
            label: Expanded(
              child: Text(
                'Akcije',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
                rows: filteredResults
                        .map(
                          (Kontakt k) => DataRow(
                            onSelectChanged: (selected) =>
                                {if (selected == true) {}},
                            cells: [
                              DataCell(Text(k.kontaktId?.toString() ?? "")),
                              DataCell(Text(k.korisnikId?.toString() ?? "")),
                              DataCell(
                                FutureBuilder(
                                  future: _getKorisnickoIme(k.korisnikId),
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
                              DataCell(Text(k.imePrezime ?? "")),
                              DataCell(Text(k.poruka ?? "")),
                              DataCell(Text(k.telefon ?? "")),
                              DataCell(Text(k.email ?? "")),
                              DataCell(
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Potvrda"),
                                          content: Text(
                                            "Jeste li sigurni da želite izbrisati ovaj kontakt?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Odustani"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                try {
                                                  await _kontaktProvider
                                                      .delete(k.kontaktId!);
                                                  // Refresh list after deletion
                                                  await initForm();
                                                } catch (e) {
                                                  print(
                                                      "Error deleting contact: $e");
                                                }
                                              },
                                              child: Text("Izbriši"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
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
}
