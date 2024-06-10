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
import 'package:rentacar_admin/screens/rezervacija_screen.dart';
import 'package:rentacar_admin/screens/vozila_detail_screen.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class VozilaListScreen extends StatefulWidget {
  static const String routeName = "/vozila";

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

  SearchResult<Vozilo>? vozilaResult;
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
    vozilaResult = await _vozilaProvider.getActiveVehicles();
    setState(() {
      isLoading = false;
    });

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
              Color.fromARGB(255, 33, 33, 33),
              Color(0xFF333333),
              Color.fromARGB(255, 150, 149, 149),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:30.0),
          child: Column(
            children: [_buildSearch(), _buildDataListView()],
          ),
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
                var data = await _vozilaProvider
                    .getActiveVehicles(filter: {'fts': _ftsController.text});
                setState(() {
                  vozilaResult = data;
                });
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
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: vozilaResult?.result
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
                              Color.fromARGB(255, 33, 33, 33),
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
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: e.slika != ""
                                        ? Container(
                                            padding: const EdgeInsets.only(
                                                top: 1, bottom: 1),
                                            child:
                                                imageFromBase64String(e.slika!),
                                          )
                                        : Container(),
                                  )),
                              Flexible(
                                flex: 1,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Model -${e.model}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
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
                                      const EdgeInsets.only(left: 20, top: 5),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month_outlined,
                                        color:
                                            Color.fromARGB(255, 139, 182, 255),
                                        size: 15,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          '${e.godinaProizvodnje}. god.',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.miscellaneous_services,
                                        color: Color.fromARGB(255, 77, 255, 83),
                                        size: 15,
                                      ),                                      const SizedBox(width: 5),

                                      Expanded(
                                        child: Text(
                                          '${(e.motor)}',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12),
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
                                      const EdgeInsets.only(left: 20, top: 5),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.local_gas_station,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          gorivoResult?.result.firstWhere((g) => g.gorivoId == e.gorivoId).tip ?? "",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.route_outlined,
                                        color: Colors.yellow,
                                        size: 15,
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${formatNumber(e.kilometraza)} km',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 12),
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
                                      horizontal: 20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              VozilaDetailScreen(vozilo: e),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Detalji i preporuke',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 13,
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
                                      horizontal: 20.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              RezervacijaScreen(vozilo: e),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Rezerviši vozilo',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 13,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(

                                      backgroundColor: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2,)
                            ]),
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
