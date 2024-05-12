import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/komentari.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/komentari_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/utils/util.dart';

class KomentariScreen extends StatefulWidget {
  final Vozilo? vozilo;

  KomentariScreen({Key? key, this.vozilo}) : super(key: key);

  @override
  State<KomentariScreen> createState() => _KomentariScreenState();
}

class _KomentariScreenState extends State<KomentariScreen> {
  late Future<List<Komentari>> _komentariFuture;
  SearchResult<Korisnici>? korisniciResult;
  late KorisniciProvider _korisniciProvider;
  late KomentariProvider _komentariProvider;
  SearchResult<Komentari>? komentariResult;
  final TextEditingController _commentController = TextEditingController();

  int? ulogovaniKorisnikId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _korisniciProvider = context.read<KorisniciProvider>();
    _komentariProvider = context.read<KomentariProvider>();

    _komentariFuture = Provider.of<KomentariProvider>(context, listen: false)
        .getCommentsForVehicle(widget.vozilo?.voziloId ?? 0);
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
        print("ID je...:$ulogovaniKorisnikId");
      });
    } catch (e) {
      print('Greška prilikom dobijanja ID-a ulogovanog korisnika: $e');
    }
  }

  Future<void> initForm() async {
    korisniciResult = await _korisniciProvider.get();
    komentariResult = await _komentariProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vozilo model: ${widget.vozilo?.model ?? ""}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FutureBuilder<List<Komentari>>(
                future: _komentariFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Greška: ${snapshot.error}'));
                  } else {
                    var komentari = snapshot.data!;
                    if (komentari.isEmpty) {
                      return Center(
                        child: Text(
                          'Vozilo nema komentara.',
                          style: TextStyle(fontSize: 16),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: komentari.length,
                      itemBuilder: (context, index) {
                        var komentar = komentari[index];
                        var korisnik = korisniciResult?.result.firstWhere(
                          (korisnik) =>
                              korisnik.korisnikId == komentar.korisnikId,
                          orElse: () => Korisnici.fromJson({}),
                        );
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${korisnik?.ime ?? 'Nepoznato'} ${korisnik?.prezime ?? 'Nepoznato'}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  komentar.komentar ?? '',
                                  style: TextStyle(fontSize: 16),
                                ),
                                if (komentar.korisnikId == ulogovaniKorisnikId)
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => _editComment(komentar),
                                        icon: Icon(Icons.edit_outlined),
                                        color: Colors.blue,
                                        iconSize: 25,
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _deleteComment(komentar),
                                        icon: Icon(Icons.delete_forever),
                                        color: Colors.red,
                                        iconSize: 25,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 226, 226, 226),
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Napišite komentar...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _saveForm,
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _deleteComment(Komentari komentar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Brisanje komentara'),
          content: Text(
            'Da li ste sigurni da želite obrisati ovaj komentar?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _komentariProvider.delete(komentar.komentarId!);
                  await _refreshComments();
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Greška pri brisanju komentara: $e');
                }
              },
              child: Text(
                'Da',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Ne',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editComment(Komentari komentar) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uredi komentar'),
          content: TextField(
            controller: TextEditingController(text: komentar.komentar),
            onChanged: (value) {
              komentar.komentar = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await _komentariProvider.update(komentar.komentarId!, {
                    'korisnikId': komentar.korisnikId,
                    'voziloId': komentar.voziloId,
                    'komentar': komentar.komentar,
                  });
                  await _refreshComments();
                  Navigator.of(context).pop();
                } catch (e) {
                  print('Greška pri ažuriranju komentara: $e');
                }
              },
              child: Text('Spremi'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Odustani'),
            ),
          ],
        );
      },
    );
  }

  void _saveForm() async {
    if (_commentController.text.isEmpty) {
      return;
    }

    try {
      await _komentariProvider.insert({
        'korisnikId': ulogovaniKorisnikId,
        'voziloId': widget.vozilo?.voziloId,
        'komentar': _commentController.text,
      });

      await _refreshComments();
      _commentController.clear();
    } catch (e) {
      print('Greška pri spremanju komentara: $e');
    }
  }

  Future<void> _refreshComments() async {
    _komentariFuture = Provider.of<KomentariProvider>(context, listen: false)
        .getCommentsForVehicle(widget.vozilo?.voziloId ?? 0);
    setState(() {});
  }
}
