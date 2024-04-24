import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/gorivo_provider.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';

import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/vozila_detail_screen.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class VozilaListScreen extends StatefulWidget {
  Vozilo? vozilo;
  VozilaListScreen({super.key, this.vozilo});

  @override
  State<VozilaListScreen> createState() => _VozilaListScreenState();
}

class _VozilaListScreenState extends State<VozilaListScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  Map<String, dynamic> _initialValue = {};
  late VozilaProvider _vozilaProvider;
  late TipVozilaProvider _tipVozilaProvider;
  late GorivoProvider _gorivoProvider;

  SearchResult<Vozilo>? result;
  SearchResult<TipVozila>? tipVozilaResult;
  SearchResult<Gorivo>? gorivoResult;

  bool isLoading = true;
  late ScaffoldMessengerState _scaffoldMessengerState;

  final TextEditingController _ftsController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'tipVozilaId': widget.vozilo?.tipVozilaId.toString(),
    };
    _tipVozilaProvider = context.read<TipVozilaProvider>();
    _vozilaProvider = context.read<VozilaProvider>();
    _gorivoProvider = context.read<GorivoProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldMessengerState = ScaffoldMessenger.of(context);
    });
    initForm();
  }

  Future<void> initForm() async {
    tipVozilaResult = await _tipVozilaProvider.get();
    gorivoResult = await _gorivoProvider.get();

    var data = await _vozilaProvider.get(filter: {'fts': _ftsController.text});
    setState(() {
      result = data;
      isLoading = false;
    });

    print(tipVozilaResult);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Vozila list"),
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
          children: [_buildSearch(), _buildDataListView()],
        ),
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
                labelText: "Filter po modelu",
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _ftsController,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                print("Login uspješan");
                var data = await _vozilaProvider
                    .get(filter: {'fts': _ftsController.text});
                setState(() {
                  result = data;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
              ),
              child: const Text("Pretraga"),
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VozilaDetailScreen(vozilo: null),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
              ),
              child: const Text("Dodaj novo vozilo"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 4,
        children: result?.result
                .map(
                  (Vozilo e) => GridTile(
                    child: Card(
                      elevation: 15,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30)),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF000000),
                              Color(0xFF333333),
                              Color.fromARGB(255, 150, 149, 149),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              flex: 4,
                              child: e.slika != ""
                                  ? Container(
                                      padding: const EdgeInsets.all(8),
                                      child: imageFromBase64String(e.slika!),
                                    )
                                  : Container(),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 8),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Model -${e.model}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_month_outlined,
                                        color:
                                            Color.fromARGB(255, 139, 182, 255)),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        '${e.godinaProizvodnje}. god.',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.attach_money_outlined,
                                        color:
                                            Color.fromARGB(255, 77, 255, 83)),
                                    Expanded(
                                      child: Text(
                                        '${formatNumber(e.cijena)} KM',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 8),
                                child: Row(
                                  children: [
                                    const Icon(Icons.local_gas_station,
                                        color: Colors.red),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        '${gorivoResult?.result.firstWhere((g) => g.gorivoId == e.gorivoId).tip ?? ""}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    const Icon(Icons.route_outlined,
                                        color: Colors.yellow),
                                    Expanded(
                                      child: Text(
                                        '${formatNumber(e.kilometraza)} km',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VozilaDetailScreen(vozilo: e),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                  ),
                                  child: const Text(
                                    'Detalji',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 80.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("Confirmation"),
                                          content: const Text(
                                              "Da li sigurno želite obrisati ovo vozilo?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.of(context).pop();
                                                try {
                                                  await _vozilaProvider
                                                      .delete(e.voziloId!);
                                                  var data =
                                                      await _vozilaProvider
                                                          .get(filter: {
                                                    'fts': _ftsController.text
                                                  });
                                                  setState(() {
                                                    result = data;
                                                  });
                                                  _scaffoldMessengerState
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Vozilo obrisano!',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                } catch (e) {
                                                  print(
                                                      "Error deleting vehicle: $e");
                                                  _scaffoldMessengerState
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'Nije moguće obrisati vozilo! $e'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              },
                                              child: const Text("Obriši"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text(
                                    'Obriši',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: PopupMenuButton<String>(
                                  child: const Text(
                                    'Opcije : Activate/Hide',
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(206, 255, 255, 2)),
                                  ),
                                  onSelected: (String action) async {
                                    if (action == "Activate") {
                                      try {
                                        await _vozilaProvider
                                            .activate(e.voziloId!);
                                        print("Vozilo u active stanju.");
                                      } catch (e) {
                                        print("Error activating vehicle: $e");
                                      }
                                    } else if (action == "Hide") {
                                      try {
                                        await _vozilaProvider.hide(e.voziloId!);
                                        print("Vozilo u hide stanju.");
                                      } catch (e) {
                                        print("Error hiding vehicle: $e");
                                      }
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return ["Activate", "Hide"]
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList() ??
            [],
      ),
    );
  }
}
