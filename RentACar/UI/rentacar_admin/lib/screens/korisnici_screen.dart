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
  late KorisniciProvider _korisniciProvider;
  final TextEditingController _ftsController = TextEditingController();
  bool isLoading = true;
  bool isUlogeIncluded = false;

  String _selectedDropdownValue = "Ne prikazuj uloge";

  @override
  void initState() {
    super.initState();
    _korisniciProvider = KorisniciProvider();
    initForm();
  }

  Future<void> initForm() async {
    await _fetchKorisnici();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchKorisnici() async {
    Map<String, dynamic>? filter = {
      'isUlogeIncluded': isUlogeIncluded, // Koristite varijablu isUlogeIncluded
      'fts': _ftsController.text,
    };
    var data = await _korisniciProvider.get(filter: filter);
    setState(() {
      korisniciResult = data;
    });
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

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: "Pretraga po imenu i prezimenu:",
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
                    await initForm();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  ),
                  child: const Text("Pretraga"),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                'Prikaz uloga za korisnike:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              DropdownButton<String>(
                style: const TextStyle(color: Colors.white),
                value: _selectedDropdownValue,
                onChanged: (String? newValue) async {
                  setState(() {
                    _selectedDropdownValue = newValue!;
                    isUlogeIncluded = _selectedDropdownValue == "Prikaži uloge";
                  });
                  await _fetchKorisnici();
                },
                items: [
                  DropdownMenuItem(
                    value: "Prikaži uloge",
                    child: Text(
                      "Prikaži uloge",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Ne prikazuj uloge",
                    child: Text(
                      "Ne prikazuj uloge",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
                dropdownColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    String searchQuery = _ftsController.text.toLowerCase();
    List<Korisnici> filteredResults = korisniciResult?.result.where((k) {
          List<String> queryParts = searchQuery.split(' ');
          String imeLower = k.ime?.toLowerCase() ?? '';
          String prezimeLower = k.prezime?.toLowerCase() ?? '';

          bool matches = queryParts.length == 2
              ? (imeLower.contains(queryParts[0]) &&
                      prezimeLower.contains(queryParts[1])) ||
                  (imeLower.contains(queryParts[1]) &&
                      prezimeLower.contains(queryParts[0]))
              : (imeLower.contains(queryParts[0]) ||
                  prezimeLower.contains(queryParts[0]));

          return matches;
        }).toList() ??
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
                  'Ime',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Prezime',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Email',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Telefon',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ),
            DataColumn(
              label: Expanded(
                child: Text(
                  'Uloge',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.white),
                ),
              ),
            ),
          ],
          rows: filteredResults
                  .map(
                    (Korisnici k) => DataRow(
                      cells: [
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
              [],
        ),
      ),
    );
  }
}
