import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/cijene_po_vremenskom_periodu.dart';
import 'package:rentacar_admin/models/period.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/cijene_po_vremenskom_periodu_provider.dart';
import 'package:rentacar_admin/providers/period_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class CijenePoVremenskomPerioduScreen extends StatefulWidget {
  CijenePoVremenskomPeriodu? cijenePoVremenskomPeriodu;
  CijenePoVremenskomPerioduScreen({super.key});

  @override
  State<CijenePoVremenskomPerioduScreen> createState() =>
      _CijenePoVremenskomPerioduScreenState();
}

class _CijenePoVremenskomPerioduScreenState
    extends State<CijenePoVremenskomPerioduScreen> {
  SearchResult<CijenePoVremenskomPeriodu>? cijenePoVremenskomPerioduResult;
  SearchResult<Period>? periodResult;
  SearchResult<Vozilo>? vozilaResult;
  late CijenePoVremenskomPerioduProvider _cijenePoVremenskomPerioduProvider;
  late PeriodProvider _periodProvider;
  late VozilaProvider _vozilaProvider;

  TextEditingController _ftsController = new TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cijenePoVremenskomPerioduProvider = CijenePoVremenskomPerioduProvider();
    _periodProvider = PeriodProvider();
    _vozilaProvider = VozilaProvider();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> initForm() async {
    cijenePoVremenskomPerioduResult =
        await _cijenePoVremenskomPerioduProvider.get();
    periodResult = await _periodProvider.get();
    vozilaResult = await _vozilaProvider.get();

    print("Cijene po vremenskom periodu: $cijenePoVremenskomPerioduResult");
    print("Periodi: $periodResult");
    print("Vozila: $vozilaResult");
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Cijene vozila"),
      child: Container(
        child: Column(children: [_buildSearch(), _buildDataListView()]),
      ),
    );
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
                labelText: "Pretraga:",
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
  Map<int, List<CijenePoVremenskomPeriodu>> groupedResults = {};
  cijenePoVremenskomPerioduResult?.result.forEach((cijena) {
    if (!groupedResults.containsKey(cijena.voziloId)) {
      groupedResults[cijena.voziloId!] = [];
    }
    groupedResults[cijena.voziloId!]!.add(cijena);
  });

  return Expanded(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          dataRowHeight: 120,
          columns: [
            DataColumn(
              label: Text(
                'Vozilo',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            DataColumn(
              label: Text(
                'Model',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            ...(periodResult?.result.map<DataColumn>((period) {
                  return DataColumn(
                    label: Text(
                      'Period ${period.trajanje}',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  );
                }).toList() ??
                []),
          ],
          rows: groupedResults.entries.map<DataRow>((entry) {
            int voziloId = entry.key;
            List<CijenePoVremenskomPeriodu> cijene = entry.value;

            Vozilo? vozilo = vozilaResult?.result
                .firstWhere((vozilo) => vozilo.voziloId == voziloId);

            return DataRow(cells: [
              DataCell(
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    width: 180,
                    height: 100,
                    child: vozilo != null && vozilo.slika != null
                        ? Image.memory(
                            base64Decode(vozilo.slika!),
                            fit: BoxFit.contain,
                          )
                        : Text(voziloId.toString()),
                  ),
                ),
              ),
              DataCell(
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(vozilo?.model ?? ""),
                ),
              ),
              ...(periodResult?.result.map<DataCell>((period) {
                    CijenePoVremenskomPeriodu? cijenaZaPeriod =
                        cijene.firstWhere(
                      (cijena) => cijena.periodId == period.periodId,
                      orElse: () => CijenePoVremenskomPeriodu.fromJson({}),
                    );
                    return DataCell(
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(cijenaZaPeriod.cijena?.toString() ?? ""),
                      ),
                    );
                  }).toList() ??
                  []),
            ]);
          }).toList(),
        ),
      ),
    ),
  );
}

}
