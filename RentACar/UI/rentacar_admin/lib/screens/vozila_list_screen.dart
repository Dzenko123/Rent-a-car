import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/models/vozila.dart';
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
  SearchResult<Vozilo>? result;
  SearchResult<TipVozila>? tipVozilaResult;
  bool isLoading = true;

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

    initForm();
  }

  Future initForm() async {
    tipVozilaResult = await _tipVozilaProvider.get();
    setState(() {
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
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/pozadinaLogin.png"),
            fit: BoxFit.cover,
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
                labelText: "FTS",
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _ftsController,
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 8),
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
              child: const Text("Pretraga"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
            ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VozilaDetailScreen(vozilo: null),
                  ),
                );
              },
              child: const Text("Dodaj novo vozilo"),
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
    return Expanded(
      child: GridView.count(
        crossAxisCount: 4,
        children: result?.result
                .map(
                  (Vozilo e) => GridTile(
                    child: Card(
                      elevation: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF000000),
                              Color(0xFF333333),
                              Color(0xFF555555),
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
                                      padding: EdgeInsets.all(8),
                                      width: double.infinity,
                                      height: 150,
                                      child: imageFromBase64String(e.slika!),
                                    )
                                  : Container(),
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8, top: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        color: Colors.white),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        'Godina proizvodnje: ${e.godinaProizvodnje}. god.',
                                        style: TextStyle(
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
                                padding: const EdgeInsets.only(left: 8, top: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.attach_money,
                                        color: Colors.white),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        'Cijena: ${formatNumber(e.cijena)} KM',
                                        style: TextStyle(
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
                                padding: const EdgeInsets.only(left: 8, top: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.speed, color: Colors.white),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        'Kilometraža: ${formatNumber(e.kilometraza)} km',
                                        style: TextStyle(
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
                                padding: const EdgeInsets.only(left: 8, top: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.car_repair, color: Colors.white),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        'Tip vozila: ${tipVozilaResult?.result.firstWhere((item) => item.tipVozilaId == e.tipVozilaId).tip ?? ""}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Flexible(
                            //   flex: 1,
                            //   child: Padding(
                            //     padding: const EdgeInsets.only(left: 8, top: 8),
                            //     child: Row(
                            //       children: [
                            //         Icon(Icons.question_mark, color: Colors.white),
                            //         SizedBox(width: 5),
                            //         Expanded(
                            //           child: Text(
                            //             'Opis: ${tipVozilaResult?.result.firstWhere((item) => item.tipVozilaId == e.tipVozilaId).opis ?? ""}',
                            //             style: TextStyle(
                            //               color: Colors.white,
                            //               fontStyle: FontStyle.italic,
                            //             ),
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 8,
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                  ),
                                  child: Text(
                                    'Detalji',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
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
