import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/main.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class ProfilScreen extends StatefulWidget {
  Korisnici? korisnik;
  List<Rezervacija>? rezervacija;
  Vozilo? vozilo;
  Grad? grad;
  ProfilScreen({Key? key, this.korisnik}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  late RezervacijaProvider _rezervacijaProvider;
  late KorisniciProvider _korisniciProvider;
  late VozilaProvider _vozilaProvider;
  late GradProvider _gradProvider;
  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Rezervacija>? rezervacijaResult;
  SearchResult<Vozilo>? voziloResult;
  SearchResult<Grad>? gradResult;

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
      SizedBox(height: 20),
      _buildUserIcon(),
      SizedBox(height: 20),
      if (widget.korisnik != null && isEditing) ...[
        FormBuilder(
          key: _formKey,
          initialValue: _initialValue,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'ime',
                initialValue: widget.korisnik?.ime,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Ime',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                name: 'prezime',
                initialValue: widget.korisnik?.prezime,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Prezime',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                name: 'email',
                initialValue: widget.korisnik?.email,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              FormBuilderTextField(
                name: 'telefon',
                initialValue: widget.korisnik?.telefon,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _updateUserProfile();
                    },
                    child: Text('Spasi'),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: Text('Odustani'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ] else if (widget.korisnik != null) ...[
        Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: _buildCombinedInfo('Ime i prezime:',
              '${widget.korisnik!.ime} ${widget.korisnik!.prezime}'),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: _buildInfoRow(Icons.email, 'Email:', widget.korisnik!.email),
        ),
        SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child:
              _buildInfoRow(Icons.phone, 'Telefon:', widget.korisnik!.telefon),
        ),
        SizedBox(height: 10),
      ] else ...[
        CircularProgressIndicator(),
      ],
      if (widget.rezervacija != null) ...[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Vaše aktivne rezervacije',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            for (var rezervacija in widget.rezervacija!) ...[
              ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder(
                      future: getVoziloData(rezervacija.voziloId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Greška prilikom dohvaćanja podataka o vozilu');
                        } else if (snapshot.hasData && snapshot.data != null) {
                          var vozilo = snapshot.data as Vozilo;
                          return Image.memory(
                            base64Decode(vozilo.slika!),
                            fit: BoxFit.cover,
                          );
                        } else {
                          return Text('Nema dostupnih informacija o vozilu');
                        }
                      },
                    ),
                    FutureBuilder(
                      future: _gradProvider.getById(rezervacija.gradId!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Greška prilikom dohvaćanja podataka o gradu');
                        } else if (snapshot.hasData && snapshot.data != null) {
                          var grad = snapshot.data as Grad;
                          return Text('Grad: ${grad.naziv}');
                        } else {
                          return Text('Nema dostupnih informacija o gradu');
                        }
                      },
                    ),
                    Text(
                        'Datum početka: ${DateFormat('dd.MM.yyyy').format(rezervacija.pocetniDatum!)}'),
                    Text(
                        'Datum završetka: ${DateFormat('dd.MM.yyyy').format(rezervacija.zavrsniDatum!)}'),
                  ],
                ),
              ),
            ],
          ],
        )
      ],
    ]);
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
          SnackBar(content: Text('Podaci korisnika su uspješno ažurirani')),
        );
        await getKorisnikData(ulogovaniKorisnikId!);

        setState(() {
          isEditing = false;
        });
      } catch (e) {
        print('Greška prilikom ažuriranja podataka korisnika: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Došlo je do greške prilikom ažuriranja')),
        );
      }
    }
  }

  Widget _buildCombinedInfo(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: TextFormField(
        style: TextStyle(fontSize: 18),
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        readOnly: !isEditing,
        onChanged: (newValue) {},
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                labelText: label,
                border: OutlineInputBorder(),
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
              icon: Icon(Icons.settings),
              tooltip: 'Postavke',
            ),
          ],
        ),
        CircleAvatar(
          backgroundColor: Colors.blue,
          radius: 50,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 48,
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
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
          title: Text('Promijenite lozinku'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _oldPasswordController,
                  decoration: InputDecoration(
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
              child: Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _verifyCurrentPassword(context);
              },
              child: Text('Dalje'),
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
          title: Text('Promijenite lozinku'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Korisničko ime'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Nova lozinka'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(labelText: 'Potvrdite lozinku'),
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
              child: Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                _changePassword();
                Navigator.of(context).pop();
              },
              child: Text('Promijeni lozinku'),
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
        SnackBar(content: Text('Lozinka uspješno promijenjena')),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ulogujte se ponovo!'),
            content: Text(
                'Vaši podaci su uspješno ažurirani. Molimo ulogujte se ponovo.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text('Uredu'),
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
          title: Text('Želite se odjaviti?'),
          content: Text('Jeste li sigurni da želite napustiti aplikaciju?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ne'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text('Da'),
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
                leading: Icon(Icons.edit),
                title: Text('Uredite profil'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    isEditing = true;
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.key),
                title: Text('Promijenite lozinku'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _showChangePasswordDialog(context);
                  });
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Odjava'),
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
