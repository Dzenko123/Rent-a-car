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

  const KomentariScreen({super.key, this.vozilo});

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
      if (mounted) {
        setState(() {
          ulogovaniKorisnikId = ulogovaniKorisnik;
        });
      }
    } catch (e) {
      print('Greška prilikom dobijanja ID-a ulogovanog korisnika: $e');
    }
  }

  Future<void> initForm() async {
    korisniciResult = await _korisniciProvider.get();
    komentariResult = await _komentariProvider.get();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Greška: ${snapshot.error}'));
                  } else {
                    var komentari = snapshot.data!;
                    if (komentari.isEmpty) {
                      return const Center(
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
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 8,
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${korisnik?.ime ?? 'Nepoznato'} ${korisnik?.prezime ?? 'Nepoznato'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  komentar.komentar ?? '',
                                  style: const TextStyle(fontSize: 16),
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
        ],
      ),
    );
  }
}
