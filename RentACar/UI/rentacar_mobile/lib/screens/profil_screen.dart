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
    _dodatnaUslugaProvider=context.read<DodatnaUslugaProvider>();
    _rezervacijaDodatnaUslugaProvider=context.read<RezervacijaDodatnaUslugaProvider>();
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
    dodatnaUslugaResult=await _dodatnaUslugaProvider.get();
    rezervacijaDodatnaUslugaResult=await _rezervacijaDodatnaUslugaProvider.get();
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
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },
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
                  }
                  return null;
                },
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
          padding: const EdgeInsets.only(bottom: 20),
          child: _buildCombinedInfo('Ime i prezime:',
              '${widget.korisnik!.ime} ${widget.korisnik!.prezime}'),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: _buildInfoRow(Icons.email, 'Email:', widget.korisnik!.email),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child:
              _buildInfoRow(Icons.phone, 'Telefon:', widget.korisnik!.telefon),
        ),
        const SizedBox(height: 10),
      ] else ...[
        const CircularProgressIndicator(),
      ],
      if (widget.rezervacija != null && widget.rezervacija!.isNotEmpty) ...[
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
            SizedBox(height: 10),
            ...widget.rezervacija!.map((rezervacija) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
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
                                } else if (snapshot.hasData && snapshot.data != null) {
                                  var vozilo = snapshot.data as Vozilo;
                                  return Image.memory(
                                    base64Decode(vozilo.slika!),
                                    fit: BoxFit.cover,
                                  );
                                } else {
                                  return const Text('Nema dostupnih informacija o vozilu');
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                              future: _gradProvider.getById(rezervacija.gradId!),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Text(
                                      'Greška prilikom dohvaćanja podataka o gradu');
                                } else if (snapshot.hasData && snapshot.data != null) {
                                  var grad = snapshot.data as Grad;
                                  return Text(
                                    'Grad: ${grad.naziv}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  );
                                } else {
                                  return const Text('Nema dostupnih informacija o gradu');
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Datum početka: ${DateFormat('dd.MM.yyyy').format(rezervacija.pocetniDatum!)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Datum završetka: ${DateFormat('dd.MM.yyyy').format(rezervacija.zavrsniDatum!)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            FutureBuilder(
                              future: getNaziviDodatnihUsluga(rezervacija.dodatnaUsluga!.map((usluga) => RezervacijaDodatnaUsluga(dodatnaUslugaId: usluga.dodatnaUslugaId)).toList()),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Dodatne usluge:',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      for (var naziv in nazivi)
                                        Text(
                                          '- $naziv',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                    ],
                                  );
                                } else {
                                  return const Text('Nema dostupnih dodatnih usluga');
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                _showCancelConfirmationDialog(rezervacija.rezervacijaId);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red
                              ),
                              child: const Text('Poništi rezervaciju',
                              style:TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ],


    ]);
  }

  void _cancelReservation(int rezervacijaId) async{
    try{
      await _rezervacijaProvider.delete(rezervacijaId);
      await _loadRezervacije();
      _showSuccessDialog();
    }
    catch(e){
      print('Greška prilikom otkazivanja rezervacije: $e');
    }
  }
  void _showCancelConfirmationDialog(int? rezervacijaId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Potvrda'),
          content: Text('Da li sigurno želite poništiti ovu rezervaciju?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ne'),
            ),
            TextButton(
              onPressed: () {
                _cancelReservation(rezervacijaId!);
                Navigator.of(context).pop();
              },
              child: Text('Da'),
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
          title: Text('Uspješno'),
          content: Text('Uspješno ste poništili rezervaciju.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<List<String>> getNaziviDodatnihUsluga(List<RezervacijaDodatnaUsluga> dodatneUsluge) async {
    List<String> nazivi = [];
    if (dodatneUsluge.isEmpty) {
      nazivi.add('Nije odabrana nijedna dodatna usluga!');
      return nazivi;
    }
    for (var dodatnaUsluga in dodatneUsluge) {
      try {
        var usluga = await _dodatnaUslugaProvider.getById(dodatnaUsluga.dodatnaUslugaId!);
        if (usluga != null) {
          nazivi.add(usluga.naziv!);

        }
        print('$nazivi');
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

        print('$request');
        await _korisniciProvider.update(ulogovaniKorisnikId!, request);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Podaci korisnika su uspješno ažurirani')),
        );
        await getKorisnikData(ulogovaniKorisnikId!);

        setState(() {
          isEditing = false;
        });
      } catch (e) {
        print('Greška prilikom ažuriranja podataka korisnika: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Došlo je do greške prilikom ažuriranja')),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                _showSettingsMenu(context);
              },
              icon: const Icon(Icons.settings),
              tooltip: 'Postavke',
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
        _usernameController.text = Authorization.username ?? '';

        return AlertDialog(
          title: const Text('Promijenite lozinku'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Trenutna lozinka',
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _verifyCurrentPassword(context);
              },
              child: const Text('Dalje'),
            ),
          ],
        );
      },
    );
  }

  void _verifyCurrentPassword(BuildContext context) async {
    try {
      if (_oldPasswordController.text != Authorization.password) {
        throw Exception('Trenutna lozinka nije ispravna');
      }
      await _showChangePasswordFields(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  Future<void> _showChangePasswordFields(BuildContext context) async {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Promijenite lozinku'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Korisničko ime'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Nova lozinka'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: 'Potvrdite lozinku'),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _changePassword();
                Navigator.of(context).pop();
              },
              child: const Text('Promijeni lozinku'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _changePassword() async {
    try {
      if (_oldPasswordController.text != Authorization.password) {
        throw Exception('Trenutni password nije ispravan');
      }

      if (_passwordController.text != _confirmPasswordController.text) {
        throw Exception('Lozinke se ne podudaraju');
      }

      if (_passwordController.text.isEmpty) {
        throw Exception('Lozinka ne smije biti prazna');
      }

      if (_usernameController.text.isEmpty) {
        throw Exception('Korisničko ime ne smije biti prazno');
      }

      await _korisniciProvider.updatePasswordAndUsername(
        ulogovaniKorisnikId!,
        _oldPasswordController.text,
        _usernameController.text,
        _passwordController.text,
        _confirmPasswordController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lozinka uspješno promijenjena')),
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
        SnackBar(content: Text('Greška prilikom promjene lozinke: $e')),
      );
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Želite se odjaviti?'),
          content: const Text('Jeste li sigurni da želite napustiti aplikaciju?'),
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
                title: const Text('Promijenite lozinku'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showChangePasswordDialog(context);
                  });
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
