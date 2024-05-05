import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/gorivo_provider.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class RecenzijeScreen extends StatefulWidget {
  final Korisnici? korisnik;
  Vozilo? vozilo;

  RecenzijeScreen({super.key, this.korisnik, this.vozilo});

  @override
  State<RecenzijeScreen> createState() => _RecenzijeScreenState();
}

class _RecenzijeScreenState extends State<RecenzijeScreen> {
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  late VozilaProvider _vozilaProvider;
  late TipVozilaProvider _tipVozilaProvider;
  late GorivoProvider _gorivoProvider;

  SearchResult<Vozilo>? result;
  SearchResult<TipVozila>? tipVozilaResult;
  SearchResult<Gorivo>? gorivoResult;
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
      title_widget: const Text("Pogledajte recenzije"),
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
        child: Column(
          children: [_buildDataListView()],
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: GridView.count(
          crossAxisCount: 1,
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
                                    flex: 6,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, bottom: 10),
                                      child: e.slika != ""
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  top: 1, bottom: 1),
                                              child: imageFromBase64String(
                                                  e.slika!),
                                            )
                                          : Container(),
                                    )),
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Model -${e.model}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
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
                                          color: Color.fromARGB(
                                              255, 139, 182, 255),
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            '${e.godinaProizvodnje}. god.',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.attach_money_outlined,
                                          color:
                                              Color.fromARGB(255, 77, 255, 83),
                                          size: 15,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${formatNumber(e.cijena)} KM',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15),
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
                                            '${gorivoResult?.result.firstWhere((g) => g.gorivoId == e.gorivoId).tip ?? ""}',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 15),
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
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        // Logika za lajk/dislajk/otvaranje ekrana za komentar
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors
                                              .transparent, // Dodajte transparentnu boju pozadine
                                        ),
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                // Logika za lajk
                                              },
                                              icon: Icon(
                                                  Icons.thumb_up_alt_outlined),
                                              color: Color.fromARGB(
                                                  255, 14, 71, 168),
                                            ),
                                            Text('Like',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            SizedBox(width: 10),
                                            IconButton(
                                              onPressed: () {
                                                // Logika za dislajk
                                              },
                                              icon: Icon(
                                                  Icons.thumb_down_outlined),
                                              color: Color.fromARGB(
                                                  210, 179, 12, 0),
                                            ),
                                            Text('Dislike',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            SizedBox(width: 10),
                                            IconButton(
                                              onPressed: () {
                                                // Logika za otvaranje ekrana za komentar
                                              },
                                              icon:
                                                  Icon(Icons.message_outlined),
                                              color: Colors.white,
                                            ),
                                            Text('Komentar',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                  )
                  .toList() ??
              [],
        ),
      ),
    );
  }
}
