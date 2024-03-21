import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';

import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/vozila_detail_screen.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class VozilaListScreen extends StatefulWidget {
  const VozilaListScreen({super.key});

  @override
  State<VozilaListScreen> createState() => _VozilaListScreenState();
}

class _VozilaListScreenState extends State<VozilaListScreen> {
  late VozilaProvider _vozilaProvider;
  SearchResult<Vozilo>? result;

  TextEditingController _ftsController = new TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _vozilaProvider = context.read<VozilaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Vozila list"),
      child: Container(
        child: Column(
          children: [_buildSearch(), _buildDataListView()],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(labelText: "FTS"),
              controller: _ftsController,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              print("Login uspješan");
              //Navigator.of(context).pop();

              var data = await _vozilaProvider
                  .get(filter: {'fts': _ftsController.text});

              setState(() {
                result = data;
              });
              print("data: ${data.result[0].dostupan}");
            },
            child: Text("Pretraga"),
          )
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
            label: const Expanded(
              child: const Text(
                'ID',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'Tip vozila ID',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'Dostupan',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'GodinaProizvodnje',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'Cijena',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'State machine',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          const DataColumn(
            label: const Expanded(
              child: const Text(
                'Slika',
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
                rows: result?.result
                        .map(
                          (Vozilo e) => DataRow(
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                print('selected: ${e.voziloId}');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => VozilaDetailScreen(vozilo: e),
                                  ),
                                );
                              }
                            },
                            cells: [
                              DataCell(Text(e.voziloId?.toString() ?? "")),
                              DataCell(Text(e.tipVozilaId?.toString() ?? "")),
                              DataCell(Text(e.dostupan?.toString() ?? "")),
                              DataCell(
                                  Text(e.godinaProizvodnje?.toString() ?? "")),
                              DataCell(
                                Text(formatNumber(e.cijena)),
                              ),
                              DataCell(Text(e.stateMachine?.toString() ?? "")),
                              DataCell(e.slika != null
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      child: imageFromBase64String(e.slika!),
                                    )
                                  : Text("")),
                            ],
                          ),
                        )
                        .toList() ??
                    [])));
  }
}
