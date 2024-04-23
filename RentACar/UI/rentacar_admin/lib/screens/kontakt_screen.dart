import 'package:flutter/material.dart';
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
          _buildDataListView()
        ]),
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
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _ftsController,
              style: TextStyle(color: Colors.white),
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
                    'Kontakt ID',
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
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                  ),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Ime i prezime',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Poruka',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Telefon',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Email',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Akcija: obriši',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, color: Colors.white),
                      ),
                    ),
                  ),
                ],
                rows: filteredResults
                        .map(
                          (Kontakt k) => DataRow(
                            // onSelectChanged: (selected) =>
                            //     {if (selected == true) {}},
                            cells: [
                              DataCell(Text(k.kontaktId?.toString() ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(k.korisnikId?.toString() ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(
                                FutureBuilder(
                                  future: _getKorisnickoIme(k.korisnikId),
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
                              DataCell(Text(k.imePrezime ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(k.poruka ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(k.telefon ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(k.email ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Potvrda"),
                                          content: const Text(
                                            "Jeste li sigurni da želite izbrisati ovaj kontakt?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Odustani"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                try {
                                                  await _kontaktProvider
                                                      .delete(k.kontaktId!);
                                                  // Refresh list after deletion
                                                  await initForm();
                                                  _showDeleteConfirmationSnackBar(); // Prikazuje Snackbar
                                                } catch (e) {
                                                  print(
                                                      "Error deleting contact: $e");
                                                }
                                              },
                                              child: const Text("Izbriši"),
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

  void _showDeleteConfirmationSnackBar() {
    final snackBar = SnackBar(
      content: Text(
        'Kontakt uspješno obrisan!',
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
