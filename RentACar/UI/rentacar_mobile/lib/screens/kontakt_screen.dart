import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/kontakt.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/providers/kontakt_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/screens/vozila_list_screen.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class KontaktScreen extends StatefulWidget {
  static const String routeName = "/kontakt";

  Kontakt? kontakt;
  KontaktScreen({super.key});

  @override
  State<KontaktScreen> createState() => _KontaktScreenState();
}

class _KontaktScreenState extends State<KontaktScreen> {
  SearchResult<Kontakt>? kontaktResult;
  SearchResult<Korisnici>? korisniciResult;
  Map<String, dynamic> _initialValue = {};
  final _formKey = GlobalKey<FormBuilderState>();
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final phoneRegex = RegExp(r'^[0-9]+$');

  late KontaktProvider _kontaktProvider;
  late KorisniciProvider _korisniciProvider;
  late int? korisnikId;
  int? ulogovaniKorisnikId;
  bool isLoading = true;
  bool _autoValidate = false;

  final TextEditingController _ftsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'imePrezime': widget.kontakt?.imePrezime,
      'poruka': widget.kontakt?.poruka,
      'email': widget.kontakt?.email,
      'telefon': widget.kontakt?.telefon
    };
    _kontaktProvider = context.read<KontaktProvider>();
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Kontakt za ID: ${ulogovaniKorisnikId.toString()}"),
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
          padding: const EdgeInsets.only(top:100.0),
          child: Column(
              children: [const SizedBox(height: 20), _buildDataListView()]),
        ),
      ),
    );
  }

  Future<void> initForm() async {
    kontaktResult = await _kontaktProvider.get();
    korisniciResult = await _korisniciProvider.get();
    var data = await _kontaktProvider.get(filter: {'fts': _ftsController.text});
    setState(() {
      kontaktResult = data;
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Widget _buildDataListView() {
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FormBuilder(
          key: _formKey,
          initialValue: _initialValue,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'imePrezime',
                initialValue: _initialValue['imePrezime'],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Ime i prezime',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },                autovalidateMode: AutovalidateMode.onUserInteraction,

              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: 'telefon',
                initialValue: _initialValue['telefon'],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Telefon',
                  hintText: "+387 62 740 788 ili +387 60 740 7888",
hintStyle: const TextStyle(color: Colors.grey),
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ), errorMaxLines: 2,
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  final regex = RegExp(
                      r'^\+387\s?(62\s?\d{3}\s?\d{3}|61\s?\d{3}\s?\d{3}|60\s?\d{3}\s?\d{4})$');
                  if (!regex.hasMatch(value)) {
                    return 'Unesite ispravan broj telefona u formatu +387 62 740 788 ili +387 60 740 7888';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,


              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: 'email',
                initialValue: _initialValue['email'],
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: "korisnik@gmail.com",
                  hintStyle: const TextStyle(color: Colors.grey),

                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),                  errorMaxLines: 4,

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
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: 'poruka',
                initialValue: _initialValue['poruka'],
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Poruka',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  return null;
                },                autovalidateMode: AutovalidateMode.onUserInteraction,

              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _saveForm();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Pošalji upit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _saveForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.saveAndValidate()) {
      var request = Map.from(_formKey.currentState!.value);
      request['korisnikId'] = ulogovaniKorisnikId;

      try {
        await _kontaktProvider.insert(request);

        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Uspješno"),
            content: const Text(
              'Vaš upit je uspješno poslan. Potruditi ćemo se da u što skorije vrijeme pregledamo i odgovorimo na Vaše pitanje. Odgovor ćete dobiti na Vašu e-mail adresu.',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Get.find<NavigationController>().selectedIndex.value = 0;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => VozilaListScreen(),
                    ),
                  );
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );

        _formKey.currentState!.reset();
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Greška"),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }
    }
  }



}
