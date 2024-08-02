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
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  String _selectedDropdownValue = "Ne prikazuj uloge";

  @override
  void initState() {
    super.initState();
    _korisniciProvider = KorisniciProvider();
    _firstNameController.addListener(_fetchKorisnici);
    _lastNameController.addListener(_fetchKorisnici);
    initForm();
  }

  Future<void> initForm() async {
    await _fetchKorisnici();
  }

  Future<void> _fetchKorisnici() async {
    Map<String, dynamic>? filter = {
      'isUlogeIncluded': _selectedDropdownValue == "Prikaži uloge",
    };
    if (_firstNameController.text.isNotEmpty) {
      filter['FirstName'] = _firstNameController.text;
    }
    if (_lastNameController.text.isNotEmpty) {
      filter['LastName'] = _lastNameController.text;
    }

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
          const Text(
            'Pretražite korisnike po imenu, prezimenu, ili oboje.',
            style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 140,
                height: 40,
                child: TextField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    hintText: 'Ime',
                    hintStyle: TextStyle(color: Colors.white54),
                    fillColor: Colors.white30,
                    filled: true,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: 140,
                height: 40,
                child: TextField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    hintText: 'Prezime',
                    hintStyle: TextStyle(color: Colors.white54),
                    fillColor: Colors.white30,
                    filled: true,
                  ),
                  style: const TextStyle(color: Colors.white),
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
          rows: korisniciResult?.result
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
