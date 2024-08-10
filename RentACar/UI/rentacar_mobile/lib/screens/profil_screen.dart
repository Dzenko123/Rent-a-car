import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/main.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/rezervacija_dodatna_usluga.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class ProfilScreen extends StatefulWidget {
  static const String routeName = "/profil";

  Korisnici? korisnik;
  List<Rezervacija>? rezervacija;
  Vozilo? vozilo;
  Grad? grad;
  DodatnaUsluga? dodatnaUsluga;

  ProfilScreen({super.key, this.korisnik});

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late RezervacijaProvider _rezervacijaProvider;
  late KorisniciProvider _korisniciProvider;
  late VozilaProvider _vozilaProvider;
  late GradProvider _gradProvider;
  late DodatnaUslugaProvider _dodatnaUslugaProvider;
  late RezervacijaDodatnaUslugaProvider _rezervacijaDodatnaUslugaProvider;

  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Rezervacija>? rezervacijaResult;
  SearchResult<Vozilo>? voziloResult;
  SearchResult<Grad>? gradResult;
  SearchResult<DodatnaUsluga>? dodatnaUslugaResult;
  SearchResult<RezervacijaDodatnaUsluga>? rezervacijaDodatnaUslugaResult;
  int? ulogovaniKorisnikId;
  bool isLoading = true;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  bool isEditing = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final _changePasswordFormKey = GlobalKey<FormState>();
  bool _isChangePasswordButtonPressed = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final phoneRegex = RegExp(r'^[0-9]+$');

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.korisnik?.ime,
      'prezime': widget.korisnik?.prezime,
      'email': widget.korisnik?.email,
      'telefon': widget.korisnik?.telefon
    };
    _korisniciProvider = context.read<KorisniciProvider>();
    _rezervacijaProvider = context.read<RezervacijaProvider>();
    _vozilaProvider = context.read<VozilaProvider>();
    _gradProvider = context.read<GradProvider>();
    _dodatnaUslugaProvider = context.read<DodatnaUslugaProvider>();
    _rezervacijaDodatnaUslugaProvider =
        context.read<RezervacijaDodatnaUslugaProvider>();
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
        if (ulogovaniKorisnikId != null) {
          getKorisnikData(ulogovaniKorisnikId!);
        }
      });
    } catch (e) {
      print('Greška prilikom dobijanja ID-a ulogovanog korisnika: $e');
    }
  }

  Future<void> getKorisnikData(int korisnikId) async {
    try {
      var result = await _korisniciProvider.getById(korisnikId);
      setState(() {
        widget.korisnik = result;
      });
    } catch (e) {
      print('Greška prilikom dobijanja podataka o korisniku: $e');
    }
  }

  Future<void> initForm() async {
    korisniciResult = await _korisniciProvider.get();
    voziloResult = await _vozilaProvider.get();
    gradResult = await _gradProvider.get();
    dodatnaUslugaResult = await _dodatnaUslugaProvider.get();
    rezervacijaDodatnaUslugaResult =
        await _rezervacijaDodatnaUslugaProvider.get();
    await getUlogovaniKorisnikId();
    if (ulogovaniKorisnikId != null) {
      await _loadRezervacije();
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadRezervacije() async {
    try {
      List<Rezervacija> rezervacije =
          await _rezervacijaProvider.getByKorisnikId(ulogovaniKorisnikId!);
      setState(() {
        widget.rezervacija = rezervacije.isNotEmpty ? rezervacije : null;
      });
    } catch (e) {
      print('Greška prilikom dobijanja rezervacija: $e');
    }
  }

  Future<Vozilo?> getVoziloData(int voziloId) async {
    try {
      var vozilo = await _vozilaProvider.getById(voziloId);
      return vozilo;
    } catch (e) {
      print('Greška prilikom dobijanja podataka o vozilu: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.korisnik != null ? 'Uredite Vaš profil.' : '',
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDataListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataListView() {
    return Column(children: [
      const SizedBox(height: 20),
      _buildUserIcon(),
      const SizedBox(height: 20),
      if (widget.korisnik != null && isEditing) ...[
        FormBuilder(
          key: _formKey,
          initialValue: _initialValue,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'ime',
                initialValue: widget.korisnik?.ime,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Ime',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'prezime',
                initialValue: widget.korisnik?.prezime,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Prezime',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'email',
                initialValue: widget.korisnik?.email,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  errorMaxLines: 4,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje ne smije biti prazno!';
                  }

                  String emailFormatExample =
                      'Primjer ispravnog formata: korisnik@gmail.com ili korisnik.korisnik@gmail.com';
                  String allowedDomains =
                      'Dozvoljene domene: gmail.com, hotmail.com, yahoo.com, outlook.com, aol.com, icloud.com';

                  String usernamePart = value.split('@').first;

                  if (RegExp(r'\.\s*[@]').hasMatch(value)) {
                    return 'Između tačke i znaka \'@\' mora biti neka riječ!';
                  }

                  if (usernamePart.contains(RegExp(r'[^a-zA-Z0-9šđčćž.]'))) {
                    return '$emailFormatExample\nKoristi se nedozvoljen znak. Dozvoljena je samo tačka i slova š, đ, č, ć, ž!';
                  }
                  if (usernamePart.split('.').length > 2) {
                    return 'Unijeli ste dvije tačke prije "@", pogrešan format!';
                  }

                  if (value.contains('@')) {
                    String domainPart = value.split('@').last;
                    List<String> allowedDomainsList = [
                      'gmail.com',
                      'hotmail.com',
                      'yahoo.com',
                      'outlook.com',
                      'aol.com',
                      'icloud.com'
                    ];
                    if (!domainPart.contains('.') ||
                        !allowedDomainsList
                            .any((domain) => domainPart.endsWith(domain))) {
                      return '$emailFormatExample\n$allowedDomains';
                    }
                  } else {
                    return emailFormatExample;
                  }

                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'telefon',
                initialValue: widget.korisnik?.telefon,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  labelStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  } else if (!phoneRegex.hasMatch(value)) {
                    return 'Broj telefona mora sadržavati samo brojeve';
                  } else if (value.length < 9) {
                    return 'Broj telefona mora imati minimalno 9 cifara';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _updateUserProfile();
                    },
                    child: const Text('Spasi'),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: const Text('Odustani'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ] else if (widget.korisnik != null) ...[
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: _buildCombinedInfo('Ime i prezime:',
              '${widget.korisnik!.ime} ${widget.korisnik!.prezime}'),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: _buildInfoRow(Icons.email, 'Email:', widget.korisnik!.email),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 25),
          child:
              _buildInfoRow(Icons.phone, 'Telefon:', widget.korisnik!.telefon),
        ),
        const SizedBox(height: 10),
      ] else ...[
        const CircularProgressIndicator(),
      ],
      if (!isEditing &&
          widget.rezervacija != null &&
          widget.rezervacija!.isNotEmpty) ...[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Vaše aktivne rezervacije',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            ...widget.rezervacija!
                .where((rezervacija) =>
                    rezervacija.pocetniDatum!.isAfter(DateTime.now()) ||
                    rezervacija.pocetniDatum!.isAtSameMomentAs(DateTime.now()))
                .map((rezervacija) {
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FutureBuilder(
                              future: getVoziloData(rezervacija.voziloId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Greška prilikom dohvaćanja podataka o vozilu');
                                } else if (snapshot.hasData &&
                                    snapshot.data != null) {
                                  var vozilo = snapshot.data as Vozilo;
                                  return vozilo.slika != null
                                      ? Image.memory(
                                          base64Decode(vozilo.slika!),
                                          fit: BoxFit.cover,
                                        )
                                      : const Text('Nema slike za prikaz');
                                } else {
                                  return const Text(
                                      'Nema dostupnih informacija o vozilu');
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                              future:
                                  _gradProvider.getById(rezervacija.gradId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Greška prilikom dohvaćanja podataka o gradu');
                                } else if (snapshot.hasData &&
                                    snapshot.data != null) {
                                  var grad = snapshot.data as Grad;
                                  return Text(
                                    'Grad: ${grad.naziv}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return const Text(
                                      'Nema dostupnih informacija o gradu');
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Datum početka: ${DateFormat('dd.MM.yyyy').format(rezervacija.pocetniDatum!)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Datum završetka: ${DateFormat('dd.MM.yyyy').format(rezervacija.zavrsniDatum!)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                              future: getNaziviDodatnihUsluga(rezervacija
                                  .dodatnaUsluga!
                                  .map((usluga) => RezervacijaDodatnaUsluga(
                                      dodatnaUslugaId: usluga.dodatnaUslugaId))
                                  .toList()),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Greška prilikom dohvaćanja naziva dodatnih usluga');
                                } else if (snapshot.hasData) {
                                  var nazivi = snapshot.data as List<String>;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Dodatne usluge:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      for (var naziv in nazivi)
                                        Text(
                                          '- $naziv',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  );
                                } else {
                                  return const Text(
                                      'Nema dostupnih dodatnih usluga');
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Ukupna cijena: ${formatNumber(rezervacija.totalPrice)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            rezervacija.zahtjev!
                                ? const Text(
                                    'Zahtjev za otkazivanje na čekanju.',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 18),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      _showCancelConfirmationDialog(
                                          rezervacija.rezervacijaId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    child: const Text(
                                      'Poništi rezervaciju',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    ]);
  }

  void _cancelReservation(int rezervacijaId) async {
    try {
      await _rezervacijaProvider.cancelReservation(rezervacijaId);
      await _loadRezervacije();
      _showSuccessDialog();
    } catch (e) {
      print('Greška prilikom otkazivanja rezervacije: $e');
    }
  }

  void _showCancelConfirmationDialog(int? rezervacijaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potvrda'),
          content:
              const Text('Da li sigurno želite poništiti ovu rezervaciju?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ne'),
            ),
            TextButton(
              onPressed: () {
                _cancelReservation(rezervacijaId!);
                Navigator.of(context).pop();
              },
              child: const Text('Da'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Uspješno'),
          content: const Text(
              'Zahtjev za poništavanje je poslan administraciji.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> getNaziviDodatnihUsluga(
      List<RezervacijaDodatnaUsluga> dodatneUsluge) async {
    List<String> nazivi = [];
    if (dodatneUsluge.isEmpty) {
      nazivi.add('Nije odabrana nijedna dodatna usluga!');
      return nazivi;
    }
    for (var dodatnaUsluga in dodatneUsluge) {
      try {
        var usluga = await _dodatnaUslugaProvider
            .getById(dodatnaUsluga.dodatnaUslugaId!);
        if (usluga != null) {
          nazivi.add(usluga.naziv!);
        }
      } catch (e) {
        print('Greška prilikom dobijanja naziva dodatne usluge: $e');
      }
    }
    return nazivi;
  }

  Future<void> _updateUserProfile() async {
    if (_formKey.currentState != null &&
        _formKey.currentState!.saveAndValidate()) {
      var request = Map.from(_formKey.currentState!.value);
      request['korisnikId'] = ulogovaniKorisnikId;
      try {
        var request = {
          'ime': _formKey.currentState?.fields['ime']?.value ?? '',
          'prezime': _formKey.currentState?.fields['prezime']?.value ?? '',
          'email': _formKey.currentState?.fields['email']?.value ?? '',
          'telefon': _formKey.currentState?.fields['telefon']?.value ?? '',
        };

        await _korisniciProvider.update(ulogovaniKorisnikId!, request);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Podaci korisnika su uspješno ažurirani'),
            backgroundColor: Colors.green,
          ),
        );
        await getKorisnikData(ulogovaniKorisnikId!);

        setState(() {
          isEditing = false;
        });
      } catch (e) {
        print('Greška prilikom ažuriranja podataka korisnika: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Došlo je do greške prilikom ažuriranja')),
        );
      }
    }
  }

  Widget _buildCombinedInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        style: const TextStyle(fontSize: 18),
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        readOnly: !isEditing,
        onChanged: (newValue) {},
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              readOnly: !isEditing,
              onChanged: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserIcon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _showSettingsMenu(context);
                  },
                  icon: const Icon(Icons.settings),
                  iconSize: 25,
                ),
                const Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: const Text(
                    'Postavke',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 50,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const CircleAvatar(
              radius: 48,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text(
                'Promijenite vaše pristupne podatke',
                style: TextStyle(fontSize: 14),
              ),
              content: Form(
                key: _changePasswordFormKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Korisničko ime (opcionalno)',
                        ),
                        onChanged: (value) {
                          _changePasswordFormKey.currentState?.validate();
                        },
                      ),
                      TextFormField(
                        controller: _oldPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Trenutna lozinka',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isOldPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isOldPasswordVisible = !_isOldPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isOldPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Polje ne smije biti prazno';
                          }
                          if (_isChangePasswordButtonPressed &&
                              value != Authorization.password) {
                            return 'Trenutna lozinka nije ispravna';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _isChangePasswordButtonPressed = false;
                          });
                          _changePasswordFormKey.currentState?.validate();
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Nova lozinka',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isNewPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Polje ne smije biti prazno';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _changePasswordFormKey.currentState?.validate();
                        },
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Ponovo unesite novu lozinku',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isConfirmPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Polje ne smije biti prazno';
                          }
                          if (value != _passwordController.text) {
                            return 'Lozinke se ne podudaraju';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          _changePasswordFormKey.currentState?.validate();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _oldPasswordController.clear();
                    _passwordController.clear();
                    _confirmPasswordController.clear();
                    _usernameController.clear();
                    setState(() {
                      _isChangePasswordButtonPressed = false;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Odustani'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isChangePasswordButtonPressed = true;
                    });
                    if (_changePasswordFormKey.currentState?.validate() ??
                        false) {
                      _changePassword();
                    }
                  },
                  child: const Text('Promijenite podatke'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _changePassword() async {
    try {
      await _korisniciProvider.updatePasswordAndUsername(
        ulogovaniKorisnikId!,
        _oldPasswordController.text,
        _usernameController.text,
        _passwordController.text,
        _confirmPasswordController.text,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ulogujte se ponovo!'),
            content: const Text(
                'Vaši podaci su uspješno ažurirani. Molimo ulogujte se ponovo.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Uredu'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom promjene podataka: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Želite se odjaviti?'),
          content:
              const Text('Jeste li sigurni da želite napustiti aplikaciju?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ne'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Da'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Uredite profil'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    isEditing = true;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.key),
                title: const Text('Promijenite pristupne podatke'),
                onTap: () {
                  Navigator.pop(context);

                    _showChangePasswordDialog(context);

                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Odjava'),
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
