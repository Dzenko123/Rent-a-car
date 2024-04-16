import 'package:flutter/cupertino.dart';
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
  TextEditingController _ftsController = new TextEditingController();
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
      title_widget: const Text("Korisnici list"),
      child: Container(
        child: Column(
          children: [
            _buildSearch(),
            _buildDataListView(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> fetchUloge() async {
    print("Fetching uloge...");
    if (korisniciResult != null) {
      for (var korisnik in korisniciResult!.result) {
        print("Uloge korisnika ${korisnik.korisnikId}: ${korisnik.uloge}");
      }
    }
  }

  Future initForm() async {
    print("Fetching korisnici...");
    korisniciResult = await _korisniciProvider.get();
    print("Korisnici fetched: $korisniciResult");
    await fetchUloge();

    var data = await _korisniciProvider.get(filter: {'fts': _ftsController.text});
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
            child: Text("Pretraga"),
          ),
          SizedBox(width: 8),
         DropdownButton<String>(
  value: _selectedDropdownValue ?? "Ne prikazuj uloge",
  onChanged: (String? newValue) async {
    setState(() {
      _selectedDropdownValue = newValue;
    });
    await fetchUloge();
  },
            items: [
              DropdownMenuItem(
                child: Text("Prikaži uloge"),
                value: "Prikaži uloge",
              ),
              DropdownMenuItem(
                child: Text("Ne prikazuj uloge"),
                value: "Ne prikazuj uloge",
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
                columns: [
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Korisnik ID',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Korisnicko ime',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Ime',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Prezime',
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
            'Telefon',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
              label: Expanded(
                  child: Text(
            'Status',
            style: TextStyle(fontStyle: FontStyle.italic),
          ))),
          const DataColumn(
            label: Expanded(
                child: Text('Uloge',
                    style: TextStyle(fontStyle: FontStyle.italic))),
          ),
        ],
                rows: korisniciResult?.result
                        .map(
                          (Korisnici k) => DataRow(
                            onSelectChanged: (selected) =>
                                {if (selected == true) {}},
                            cells: [
                              DataCell(Text(k.korisnikId?.toString() ?? "")),
                              DataCell(Text(k.korisnickoIme ?? "")),
                              DataCell(Text(k.ime ?? "")),
                              DataCell(Text(k.prezime ?? "")),
                              DataCell(Text(k.email ?? "")),
                              DataCell(Text(k.telefon ?? "")),
                              DataCell(Text(k.status?.toString() ?? "")),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: k.uloge?.map((Uloge? uloga) {
                                          return Text(uloga?.naziv ?? '');
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
