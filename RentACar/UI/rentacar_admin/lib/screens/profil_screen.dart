import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/main.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';

import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class ProfilScreen extends StatefulWidget {
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
  late KorisniciProvider _korisniciProvider;

  SearchResult<Korisnici>? korisniciResult;

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
    await getUlogovaniKorisnikId();
    setState(() {
      isLoading = false;
    });
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
                    return 'Polje ne smije biti prazno!';
                  }

                  String emailFormatExample =
                      'Primjer ispravnog formata: korisnik@gmail.com';
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
                    return 'Unijeli ste dvije tačke, pogrešan format!';
                  }

                  if (value.contains('@')) {
                    String domainPart = value.split('@').last;
                    List<String> allowedDomainsList = [
                      'gmail.com',
                      'hotmail.com'
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
                onChanged: (value) {
                  _formKey.currentState?.validate();
                },
              ),
              const SizedBox(height: 10),
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
                  final phoneRegex = RegExp(r'^\d{9,}$');
                  if (!phoneRegex.hasMatch(value)) {
                    return 'Unesite ispravan telefon (minimum 9 cifara, samo brojevi)';
                  }
                  return null;
                },
                onChanged: (value) {
                  _formKey.currentState?.save();
                  _formKey.currentState?.validate();
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
          padding: const EdgeInsets.only(left: 150, right: 150),
          child:
              _buildInfoRow(Icons.verified_user, 'Ime:', widget.korisnik!.ime),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 150, right: 150),
          child: _buildInfoRow(
              Icons.verified_user, 'Prezime:', widget.korisnik!.prezime),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 150, right: 150),
          child: _buildInfoRow(Icons.email, 'Email:', widget.korisnik!.email),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 150, right: 150),
          child:
              _buildInfoRow(Icons.phone, 'Telefon:', widget.korisnik!.telefon),
        ),
        const SizedBox(height: 10),
      ] else ...[
        const CircularProgressIndicator(),
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

        await _korisniciProvider.update(ulogovaniKorisnikId!, request);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Podaci korisnika su uspješno ažurirani')),
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
      // Pomjeri ikonu ulijevo
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end, // Postavi mainAxisAlignment na end
          children: [
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    _showSettingsMenu(context);
                  },
                  icon: const Icon(Icons.settings, size: 35), // Povećaj veličinu ikone
                ),
                const Text(
                  'Postavke',
                  style: TextStyle(fontSize: 14), // Postavi veličinu fonta
                ),
              ],
            ),
          ],
        ),
      ),
      // Povećaj veličinu CircleAvatar
      CircleAvatar(
        backgroundColor: Colors.blue,
        radius: 60, // Povećaj radius
        child: Container(
          padding: const EdgeInsets.all(4), // Povećaj padding za veći krug oko avatar
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const CircleAvatar(
            radius: 58, // Povećaj radius
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 60, // Povećaj veličinu ikone unutar avatar
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
      return AlertDialog(
        title: const Text('Promijenite lozinku'),
        content: Form(
          key: _changePasswordFormKey,
          child: SingleChildScrollView(
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje ne smije biti prazno';
                    }
                    // Show error only if the button is pressed
                    if (_isChangePasswordButtonPressed && value != Authorization.password) {
                      return 'Trenutna lozinka nije ispravna';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Clear the button press flag on text change
                    setState(() {
                      _isChangePasswordButtonPressed = false;
                    });
                    // Trigger form validation when the input changes
                    _changePasswordFormKey.currentState?.validate();
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Nova lozinka',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje ne smije biti prazno';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // Trigger form validation when the input changes
                    _changePasswordFormKey.currentState?.validate();
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Ponovo unesite novu lozinku',
                  ),
                  obscureText: true,
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
                    // Trigger form validation when the input changes
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
              // Clear controllers and reset flag
              _oldPasswordController.clear();
              _passwordController.clear();
              _confirmPasswordController.clear();
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
                _isChangePasswordButtonPressed = true; // Set the flag to true
              });
              if (_changePasswordFormKey.currentState?.validate() ?? false) {
                _changePassword();
              }
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
      // All validation is handled in the form validator
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

  void _verifyCurrentPassword(BuildContext context) async {
    try {
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
                  decoration:
                      const InputDecoration(labelText: 'Korisničko ime'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Nova lozinka'),
                  obscureText: true,
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Potvrdite lozinku'),
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
              )
            ],
          ),
        );
      },
    );
  }
}
