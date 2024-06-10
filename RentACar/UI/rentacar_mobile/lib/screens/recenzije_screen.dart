import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/models/komentari.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/recenzije.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/gorivo_provider.dart';
import 'package:rentacar_admin/providers/komentari_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/recenzije_provider.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/komentari_screen.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class RecenzijeScreen extends StatefulWidget {
  static const String routeName = "/recenzije";

  final Korisnici? korisnik;
  Vozilo? vozilo;
  Komentari? komentar;
  Recenzije? recenzije;

  RecenzijeScreen(
      {super.key, this.korisnik, this.vozilo, this.komentar, this.recenzije});

  @override
  State<RecenzijeScreen> createState() => _RecenzijeScreenState();
}

class _RecenzijeScreenState extends State<RecenzijeScreen> {
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  late VozilaProvider _vozilaProvider;
  late TipVozilaProvider _tipVozilaProvider;
  late GorivoProvider _gorivoProvider;
  late KomentariProvider _komentariProvider;
  late RecenzijeProvider _recenzijeProvider;
  late KorisniciProvider _korisniciProvider;

  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Vozilo>? result;
  SearchResult<TipVozila>? tipVozilaResult;
  SearchResult<Gorivo>? gorivoResult;
  SearchResult<Komentari>? komentariResult;
  SearchResult<Recenzije>? recenzijeResult;

  final TextEditingController _ftsController = TextEditingController();
  int? ulogovaniKorisnikId;
  late bool isLiked;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'tipVozilaId': widget.vozilo?.tipVozilaId.toString(),
    };
    isLiked = widget.recenzije?.isLiked ?? false;
    _tipVozilaProvider = context.read<TipVozilaProvider>();
    _vozilaProvider = context.read<VozilaProvider>();
    _gorivoProvider = context.read<GorivoProvider>();
    _komentariProvider = context.read<KomentariProvider>();
    _recenzijeProvider = context.read<RecenzijeProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    getUlogovaniKorisnikId();

    initForm();
  }

  Future<void> getUlogovaniKorisnikId() async {
    try {
      var ulogovaniKorisnik = await _korisniciProvider.getLoged(
        Authorization.username ?? '',
        Authorization.password ?? '',
      );
      setState(() {
        ulogovaniKorisnikId = ulogovaniKorisnik;
      });
    } catch (e) {
      print('Greška prilikom dobijanja ID-a ulogovanog korisnika: $e');
    }
  }

  Future<void> initForm() async {
    korisniciResult = await _korisniciProvider.get();

    tipVozilaResult = await _tipVozilaProvider.get();
    gorivoResult = await _gorivoProvider.get();
    komentariResult = await _komentariProvider.get();
    recenzijeResult = await _recenzijeProvider.get();

    var data = await _vozilaProvider.get(filter: {'fts': _ftsController.text});

    setState(() {
      result = data;
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
        padding: const EdgeInsets.only(top:30.0, left:30, right: 30),
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
                                          Icons.miscellaneous_services,
                                          color:
                                              Color.fromARGB(255, 77, 255, 83),
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),

                                        Expanded(
                                          child: Text(
                                            '${(e.motor)}',
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
                                            gorivoResult?.result.firstWhere((g) => g.gorivoId == e.gorivoId).tip ?? "",
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
                                const SizedBox(
                                  height: 10,
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color.fromARGB(
                                                255, 5, 102, 182),
                                          ),
                                          child: const Icon(
                                            Icons.thumb_up_alt_rounded,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        if (recenzijeResult?.result.any(
                                                (recenzija) =>
                                                    recenzija.voziloId ==
                                                        e.voziloId &&
                                                    recenzija.korisnikId ==
                                                        ulogovaniKorisnikId &&
                                                    recenzija.isLiked ==
                                                        true) ??
                                            false)
                                          if (recenzijeResult?.result
                                                      .where((recenzija) =>
                                                          recenzija.voziloId ==
                                                              e.voziloId &&
                                                          recenzija.isLiked ==
                                                              true)
                                                      .length ==
                                                  1 ??
                                              false)
                                            const Text(
                                              'Sviđa vam se',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                              ),
                                            )
                                          else
                                            Text(
                                              'Vi i ${recenzijeResult!.result.where((recenzija) => recenzija.voziloId == e.voziloId && recenzija.isLiked == true).length - 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                              ),
                                            )
                                        else
                                          Text(
                                            '${recenzijeResult?.result.where((recenzija) => recenzija.voziloId == e.voziloId && recenzija.isLiked == true).length ?? 0}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                            ),
                                          ),
                                        const SizedBox(width: 10),
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                Color.fromARGB(255, 182, 5, 5),
                                          ),
                                          child: const Icon(
                                            Icons.thumb_down_alt_rounded,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        if (recenzijeResult?.result.any(
                                                (recenzija) =>
                                                    recenzija.voziloId ==
                                                        e.voziloId &&
                                                    recenzija.korisnikId ==
                                                        ulogovaniKorisnikId &&
                                                    recenzija.isLiked ==
                                                        false) ??
                                            false)
                                          if (recenzijeResult?.result
                                                      .where((recenzija) =>
                                                          recenzija.voziloId ==
                                                              e.voziloId &&
                                                          recenzija.isLiked ==
                                                              false)
                                                      .length ==
                                                  1 ??
                                              false)
                                            const Text(
                                              'Ne sviđa vam se',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                              ),
                                            )
                                          else
                                            Text(
                                              'Vi i ${recenzijeResult!.result.where((recenzija) => recenzija.voziloId == e.voziloId && recenzija.isLiked == false).length - 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 14,
                                              ),
                                            )
                                        else
                                          Text(
                                            '${recenzijeResult?.result.where((recenzija) => recenzija.voziloId == e.voziloId && recenzija.isLiked == false).length ?? 0}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontStyle: FontStyle.italic,
                                              fontSize: 14,
                                            ),
                                          ),
                                        const SizedBox(width: 10),
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                          ),
                                          child: const Icon(
                                            Icons.message_rounded,
                                            color: Colors.white,
                                            size: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${komentariResult?.result.where((komentar) => komentar.voziloId == e.voziloId).length ?? 0} komentar/a',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontStyle: FontStyle.italic,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(
                                      right: 8.0, left: 8.0),
                                  child: Divider(
                                    color: Colors.white,
                                    thickness: 1.2,
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: InkWell(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromARGB(
                                              200, 255, 255, 255),
                                        ),
                                        child: Row(
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                likeButtonPressed(e.voziloId!);
                                              },
                                              icon: Icon(
                                                recenzijeResult!.result.any(
                                                        (recenzija) =>
                                                            recenzija
                                                                    .voziloId ==
                                                                e.voziloId &&
                                                            recenzija
                                                                    .korisnikId ==
                                                                ulogovaniKorisnikId &&
                                                            recenzija.isLiked ==
                                                                true)
                                                    ? Icons.thumb_up_alt_rounded
                                                    : Icons
                                                        .thumb_up_alt_outlined,
                                                color: recenzijeResult!.result
                                                        .any((recenzija) =>
                                                            recenzija
                                                                    .voziloId ==
                                                                e.voziloId &&
                                                            recenzija
                                                                    .korisnikId ==
                                                                ulogovaniKorisnikId &&
                                                            recenzija.isLiked ==
                                                                true)
                                                    ? const Color.fromARGB(
                                                        255, 5, 102, 182)
                                                    : const Color.fromARGB(
                                                        210, 0, 0, 0),
                                              ),
                                              label: Text(
                                                'Like',
                                                style: TextStyle(
                                                  color: recenzijeResult!
                                                          .result
                                                          .any((recenzija) =>
                                                              recenzija
                                                                      .voziloId ==
                                                                  e.voziloId &&
                                                              recenzija
                                                                      .korisnikId ==
                                                                  ulogovaniKorisnikId &&
                                                              recenzija
                                                                      .isLiked ==
                                                                  true)
                                                      ? const Color.fromARGB(
                                                          255, 5, 102, 182)
                                                      : const Color.fromARGB(
                                                          210, 0, 0, 0),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  Colors.transparent,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            TextButton.icon(
                                              onPressed: () {
                                                dislikeButtonPressed(
                                                    e.voziloId!);
                                              },
                                              icon: Icon(
                                                recenzijeResult!
                                                        .result
                                                        .any((recenzija) =>
                                                            recenzija
                                                                    .voziloId ==
                                                                e.voziloId &&
                                                            recenzija
                                                                    .korisnikId ==
                                                                ulogovaniKorisnikId &&
                                                            recenzija.isLiked ==
                                                                false)
                                                    ? Icons
                                                        .thumb_down_alt_rounded
                                                    : Icons.thumb_down_outlined,
                                                color: recenzijeResult!.result
                                                        .any((recenzija) =>
                                                            recenzija
                                                                    .voziloId ==
                                                                e.voziloId &&
                                                            recenzija
                                                                    .korisnikId ==
                                                                ulogovaniKorisnikId &&
                                                            recenzija.isLiked ==
                                                                false)
                                                    ? const Color.fromARGB(
                                                        255, 182, 5, 5)
                                                    : const Color.fromARGB(
                                                        210, 0, 0, 0),
                                              ),
                                              label: Text(
                                                'Dislike',
                                                style: TextStyle(
                                                  color: recenzijeResult!.result
                                                          .any((recenzija) =>
                                                              recenzija
                                                                      .voziloId ==
                                                                  e.voziloId &&
                                                              recenzija
                                                                      .korisnikId ==
                                                                  ulogovaniKorisnikId &&
                                                              recenzija
                                                                      .isLiked ==
                                                                  false)
                                                      ? const Color.fromARGB(
                                                          255, 182, 5, 5)
                                                      : const Color.fromARGB(
                                                          210, 0, 0, 0),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  Colors.transparent,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            TextButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        KomentariScreen(
                                                            vozilo: e),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.messenger_outline_rounded,
                                                color: Color.fromARGB(
                                                    210, 0, 0, 0),
                                              ),
                                              label: const Text(
                                                'Komentar',
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      210, 0, 0, 0),
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStateProperty.all(
                                                  Colors.transparent,
                                                ),
                                              ),
                                            ),
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

  Future<void> likeOrDislike(int voziloId, bool isLiked) async {
    try {
      if (ulogovaniKorisnikId != null) {
        showLoadingDialog(context);

        var existingRecenzija = recenzijeResult?.result.firstWhereOrNull(
          (recenzija) =>
              recenzija.voziloId == voziloId &&
              recenzija.korisnikId == ulogovaniKorisnikId,
        );

        if (existingRecenzija != null) {
          if (existingRecenzija.isLiked == isLiked) {
            await _recenzijeProvider.delete(existingRecenzija.recenzijaId!);
          } else {
            existingRecenzija.isLiked = isLiked;
            await _recenzijeProvider.update(
              existingRecenzija.recenzijaId!,
              existingRecenzija,
            );
          }
        } else {
          var novaRecenzija = Recenzije(
            korisnikId: ulogovaniKorisnikId!,
            voziloId: voziloId,
            isLiked: isLiked,
          );
          await _recenzijeProvider.insert(novaRecenzija);
        }

        await initForm();

        hideLoadingDialog(context);
      }
    } catch (e) {
      print('Greška prilikom lajkovanja/dislajkovanja recenzije: $e');
      hideLoadingDialog(context);
    }
  }

  void likeButtonPressed(int voziloId) async {
    await likeOrDislike(voziloId, true);
  }

  void dislikeButtonPressed(int voziloId) async {
    await likeOrDislike(voziloId, false);
  }

  late OverlayEntry _overlayEntry;

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text(
                'Molimo pričekajte...',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
