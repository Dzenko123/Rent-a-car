import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';

import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/vozila_detail_screen.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class VozilaListScreen extends StatefulWidget {
  final bool showBackButton;

  const VozilaListScreen({Key? key, this.showBackButton = true}) : super(key: key);

  @override
  State<VozilaListScreen> createState() => _VozilaListScreenState();
}


class _VozilaListScreenState extends State<VozilaListScreen> {
  late VozilaProvider _vozilaProvider;
  SearchResult<Vozilo>? result;

  final TextEditingController _ftsController = TextEditingController();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _vozilaProvider = context.read<VozilaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Vozila list"),
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
              decoration: const InputDecoration(labelText: "FTS"),
              controller: _ftsController,
            ),
          ),
          const SizedBox(
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
              //  print("data: ${data.result[0].dostupan}");
            },
            child: const Text("Pretraga"),
          ),
          const SizedBox(
            height: 8,
          ),
          ElevatedButton(
            onPressed: () async {
              //Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => VozilaDetailScreen(vozilo: null),
                ),
              );
            },
            child: const Text("Dodaj"),
          )
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
            child: DataTable(
                columns: const [
          DataColumn(
            label: Expanded(
              child: Text(
                'ID',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Tip vozila ID',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'GodinaProizvodnje',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Cijena',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Dostupan',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'StateMachine',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Kilometraža',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
          DataColumn(
            label: Expanded(
              child: Text(
                'Slika',
                style: TextStyle(fontStyle: FontStyle.italic),
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
                                    builder: (context) =>
                                        VozilaDetailScreen(vozilo: e),
                                  ),
                                );
                              }
                            },
                            cells: [
                              DataCell(Text(e.voziloId?.toString() ?? "")),
                              DataCell(Text(e.tipVozilaId?.toString() ?? "")),
                              DataCell(
                                  Text(e.godinaProizvodnje?.toString() ?? "")),
                              DataCell(
                                Text(formatNumber(e.cijena)),
                              ),
                              DataCell(Text(e.dostupan?.toString() ?? "")),
                              DataCell(
                                (Text(e.stateMachine?.toString() ?? "")),
                              ),
                              DataCell(Text(e.kilometraza?.toString() ?? "")),
                              DataCell(e.slika != ""
                                  ? Container(
                                      width: 150,
                                      height: 150,
                                      child: imageFromBase64String(e.slika!),
                                    )
                                  : const Text("")),
                            ],
                          ),
                        )
                        .toList() ??
                    [])));
  }
}
