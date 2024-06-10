import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/uloge.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class KorisniciListScreen extends StatefulWidget {
  Korisnici? korisnici;
  KorisniciListScreen({super.key});

  @override
  State<KorisniciListScreen> createState() => _KorisniciListScreenState();
}

class _KorisniciListScreenState extends State<KorisniciListScreen> {
  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Uloge>? ulogeResult;
  late KorisniciProvider _korisniciProvider;
  final TextEditingController _ftsController = TextEditingController();
  bool isLoading = true;
  String? _selectedDropdownValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _korisniciProvider = KorisniciProvider();
    initForm();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Korisnici"),
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
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSearch(),
            const SizedBox(height: 30),
            _buildDataListView(),
          ],
        ),
      ),
    );
  }

  Future<void> fetchUloge() async {
    if (korisniciResult != null) {
      for (var korisnik in korisniciResult!.result) {
        print("${korisnik.uloge}");
      }
    }
  }

  Future initForm() async {
    korisniciResult = await _korisniciProvider.get();
    await fetchUloge();

    var data =
        await _korisniciProvider.get(filter: {'fts': _ftsController.text});
    setState(() {
      korisniciResult = data;
      isLoading = false;
    });
  }

 Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const SizedBox(width: 8),
          DropdownButton<String>(
            style: const TextStyle(color: Colors.white),
            value: _selectedDropdownValue ?? "Ne prikazuj uloge",
            onChanged: (String? newValue) async {
              setState(() {
                _selectedDropdownValue = newValue;
              });
              await fetchUloge();
            },
            items: [
              DropdownMenuItem(
                value: "Prikaži uloge",
                child: Text(
                  "Prikaži uloge",
                  style: TextStyle(
                      color: _selectedDropdownValue == "Prikaži uloge"
                          ? Colors.white
                          : Colors.white),
                ),
              ),
              DropdownMenuItem(
                value: "Ne prikazuj uloge",
                child: Text(
                  "Ne prikazuj uloge",
                  style: TextStyle(
                      color: _selectedDropdownValue == "Ne prikazuj uloge"
                          ? Colors.white
                          : Colors.white),
                ),
              ),
            ],
            dropdownColor: Colors.black,
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () async {
              await initForm();
              var data = await _korisniciProvider.get(
                filter: {
                  'fts': _ftsController.text,
                  'isUlogeIncluded': _selectedDropdownValue == "Prikaži uloge"
                },
              );
              setState(() {
                korisniciResult = data;
              });
              await fetchUloge();
            },
            child: const Text("Pretraga"),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
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
                    'Korisnik ID',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Ime',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    'Prezime',
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
                    'Telefon',
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white),
                  ))),
                 
                  DataColumn(
                    label: Expanded(
                        child: Text('Uloge',
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white))),
                  ),
                ],
                rows: korisniciResult?.result
                        .map(
                          (Korisnici k) => DataRow(
                            
                            cells: [
                              DataCell(Text(k.korisnikId?.toString() ?? "",
                                  style: const TextStyle(color: Colors.white))),
                             
                              DataCell(Text(k.ime ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(k.prezime ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(k.email ?? "",
                                  style: const TextStyle(color: Colors.white))),
                              DataCell(Text(k.telefon ?? "",
                                  style: const TextStyle(color: Colors.white))),
                            
                              DataCell(
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: k.uloge?.map((Uloge? uloga) {
                                          return Text(uloga?.naziv ?? '',
                                              style: const TextStyle(
                                                  color: Colors.white));
                                        }).toList() ??
                                        [],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList() ??
                    [])));
  }
}
