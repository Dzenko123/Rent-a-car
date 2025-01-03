import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/providers/cijene_po_vremenskom_periodu_provider.dart';
import 'package:rentacar_admin/providers/dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/gorivo_provider.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/providers/komentari_provider.dart';
import 'package:rentacar_admin/providers/kontakt_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/recenzije_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';
import 'package:rentacar_admin/providers/to_do_4924_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/providers/vozilo_pregled_provider.dart';
import 'package:rentacar_admin/screens/cijene_po_vremenskom_periodu_screen.dart';
import 'package:rentacar_admin/screens/kontakt_screen.dart';
import 'package:rentacar_admin/screens/profil_screen.dart';
import 'package:rentacar_admin/screens/recenzije_screen.dart';
import 'package:rentacar_admin/screens/to_do_4924_screen.dart';
import 'package:rentacar_admin/utils/util.dart';
import './screens/vozila_list_screen.dart';
import 'package:flutter/material.dart' as FlutterMaterial;

import '.env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey= stripePublishableKey;
  await Stripe.instance.applySettings();

  HttpOverrides.global = MyHttpOverrides();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => VozilaProvider()),
    ChangeNotifierProvider(create: (_) => TipVozilaProvider()),
    ChangeNotifierProvider(create: (_) => GorivoProvider()),
    ChangeNotifierProvider(create: (_) => KorisniciProvider()),
    ChangeNotifierProvider(create: (_) => KontaktProvider()),
    ChangeNotifierProvider(create: (_) => KomentariProvider()),
    ChangeNotifierProvider(create: (_) => RecenzijeProvider()),
    ChangeNotifierProvider(create: (_) => VoziloPregledProvider()),
    ChangeNotifierProvider(create: (_) => RezervacijaProvider()),
    ChangeNotifierProvider(create: (_) => CijenePoVremenskomPerioduProvider()),
    ChangeNotifierProvider(create: (_) => GradProvider()),
    ChangeNotifierProvider(create: (_) => DodatnaUslugaProvider()),
    ChangeNotifierProvider(create: (_) => RezervacijaDodatnaUslugaProvider()),
    ChangeNotifierProvider(create: (_) => ToDo4924ModelProvider()),
  ], child: const MyMaterialApp()));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RS II Material App',
      home: const LoginPage(),
      onGenerateRoute: (settings) {
        if (settings.name == VozilaListScreen.routeName) {
          if (!Get.isDialogOpen!) {
            return GetPageRoute(
              settings: settings,
              page: () => VozilaListScreen(),
            );
          }
        } else if (settings.name == CijenePoVremenskomPerioduScreen.routeName) {
          if (!Get.isDialogOpen!) {
            return GetPageRoute(
              settings: settings,
              page: () => CijenePoVremenskomPerioduScreen(),
            );
          }
        }else if (settings.name == RecenzijeScreen.routeName) {
          if (!Get.isDialogOpen!) {
            return GetPageRoute(
              settings: settings,
              page: () => RecenzijeScreen(),
            );
          }
        }else if (settings.name == KontaktScreen.routeName) {
          if (!Get.isDialogOpen!) {
            return GetPageRoute(
              settings: settings,
              page: () => KontaktScreen(),
            );
          }
        }else if (settings.name == ProfilScreen.routeName) {
          if (!Get.isDialogOpen!) {
            return GetPageRoute(
              settings: settings,
              page: () => ProfilScreen(),
            );
          }

        }
        else if (settings.name == ToDo4924ListScreen.routeName) {
          if (!Get.isDialogOpen!) {
            return GetPageRoute(
              settings: settings,
              page: () => ToDo4924ListScreen(),
            );
          }
        }
        return null;
      },
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.9)),
          ),
          fillColor: Colors.transparent,
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _imeController = TextEditingController();
  final TextEditingController _prezimeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefonController = TextEditingController();
  final TextEditingController _korisnickoImeController =
      TextEditingController();
  final TextEditingController _noviPasswordController = TextEditingController();
  final TextEditingController _passwordPotvrdaController =
      TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  late KorisniciProvider _korisniciProvider;
  final _changePasswordFormKey = GlobalKey<FormState>();

  late VozilaProvider _vozilaProvider;
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordObscured = true;
  bool _isSignUpMode = false;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _vozilaProvider = context.read<VozilaProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/lambo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isSignUpMode) ...[
                  Container(
                    constraints:
                        const BoxConstraints(maxHeight: 330, maxWidth: 320),
                    child: FlutterMaterial.Card(
                      elevation: 5,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                          color: Colors.white,
                          width: 1.5,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF000000),
                              Color(0xFF333333),
                              Color(0xFF555555),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: SingleChildScrollView(
                            child: Form(  key: _formKey,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  TextFormField(
                                    cursorColor: Colors.white,
                                    decoration: const InputDecoration(
                                      labelText: "Username",
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.white,
                                      ),
                                      labelStyle: TextStyle(color: Colors.white),
                                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                                    ),
                                    controller: _usernameController,
                                    style: const TextStyle(color: Colors.white),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Molimo unesite korisničko ime';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  TextFormField(
                                    cursorColor: Colors.white,
                                    decoration: InputDecoration(
                                      labelText: "Password",
                                      prefixIcon: const Icon(
                                        Icons.password,
                                        color: Colors.white,
                                      ),
                                      labelStyle: const TextStyle(color: Colors.white),
                                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _isPasswordObscured
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _isPasswordObscured =
                                            !_isPasswordObscured;
                                          });
                                        },
                                      ),
                                    ),
                                    controller: _passwordController,
                                    style: const TextStyle(color: Colors.white),
                                    obscureText: _isPasswordObscured,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Molimo unesite lozinku';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 40),
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        var username = _usernameController.text;
                                        var password = _passwordController.text;
                                        Authorization.username = username;
                                        Authorization.password = password;

                                        try {
                                          var loginData = await _korisniciProvider.getLogedWithRole(username, password);

                                          if (loginData != null && loginData['uloga'] == 'user') {
                                            await _vozilaProvider.get();
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => VozilaListScreen(),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                title: Text("Greška"),
                                                content: Text("Nemate dozvolu za pristup."),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: Text("OK"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        } on Exception catch (e) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: Text("Greška"),
                                              content: Text(e.toString()),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context),
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(
                                      "Login",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            )

                          ),
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  Form(
                    key: _changePasswordFormKey,

                    child: Container(
                      constraints:
                          const BoxConstraints(maxHeight: 350, maxWidth: 320),
                      child: FlutterMaterial.Card(
                        elevation: 5,
                        color: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: const BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF000000),
                                Color(0xFF333333),
                                Color(0xFF555555),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ScrollbarTheme(
                            data: ScrollbarThemeData(
                              thumbColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                            ),
                            child: Scrollbar(
                              controller: _scrollController,
                              thumbVisibility: true,
                              trackVisibility: true,
                              thickness: 9,
                              radius: const Radius.circular(50),
                              interactive: true,
                              child: Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                            labelText: "Ime",
                                            prefixIcon: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            labelStyle:
                                                const TextStyle(color: Colors.white),
                                            contentPadding:
                                                const EdgeInsets.symmetric(vertical: 5),
                                            errorText: _imeController.text.isEmpty
                                                ? 'Polje ne smije biti prazno'
                                                : null,
                                            errorStyle:
                                                const TextStyle(color: Colors.white)),
                                        style:
                                            const TextStyle(color: Colors.white),
                                        controller: _imeController,
                                        onChanged: (_) {
                                          setState(() {});
                                        },
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                            labelText: "Prezime",
                                            prefixIcon: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            labelStyle:
                                                const TextStyle(color: Colors.white),
                                            contentPadding:
                                                const EdgeInsets.symmetric(vertical: 5),
                                            errorText:
                                                _prezimeController.text.isEmpty
                                                    ? 'Polje ne smije biti prazno'
                                                    : null,
                                            errorStyle:
                                                const TextStyle(color: Colors.white)),
                                        style:
                                            const TextStyle(color: Colors.white),
                                        controller: _prezimeController,
                                        onChanged: (_) {
                                          setState(() {});
                                        },
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          labelText: "Email",
                                          prefixIcon: const Icon(
                                            Icons.email,
                                            color: Colors.white,
                                          ),
                                          labelStyle: const TextStyle(color: Colors.white),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                          errorStyle: const TextStyle(color: Colors.white),
                                          errorMaxLines: 6,
                                            errorText:
                                            _emailController.text.isEmpty
                                                ? 'Polje ne smije biti prazno'
                                                : null,

                                        ),
                                        style: const TextStyle(color: Colors.white),

                                        controller: _emailController,
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
                                        onChanged: (_) {
                                          setState(() {});
                                        },
                                      ),


                                      const SizedBox(
                                        height: 8,
                                      ),

                                      TextFormField(
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          labelText: "Telefon",
                                          prefixIcon: const Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          ),
                                          labelStyle: const TextStyle(color: Colors.white),
                                          contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                          errorStyle: const TextStyle(color: Colors.white),
                                          errorText: _telefonController.text.isEmpty
                                              ? 'Polje ne smije biti prazno'
                                              : null,
                                          errorMaxLines: 2,
                                        ),
                                        style: const TextStyle(color: Colors.white),
                                        controller: _telefonController,
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
                                        onChanged: (_) {
                                          setState(() {});
                                        },
                                      ),



                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                        height: 1,
                                        thickness: 5,
                                      ),
                                      TextField(
                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                            labelText: "Korisnicko ime",
                                            prefixIcon: const Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                            labelStyle:
                                                const TextStyle(color: Colors.white),
                                            contentPadding:
                                                const EdgeInsets.symmetric(vertical: 5),
                                            errorText: _korisnickoImeController
                                                    .text.isEmpty
                                                ? 'Polje ne smije biti prazno'
                                                : null,
                                            errorStyle:
                                                const TextStyle(color: Colors.white)),
                                        style:
                                            const TextStyle(color: Colors.white),
                                        controller: _korisnickoImeController,
                                        onChanged: (_) {
                                          setState(() {});
                                        },
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        controller: _noviPasswordController,
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          prefixIcon: const Icon(
                                            Icons.password_sharp,
                                            color: Colors.white,
                                          ),
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
                                            color: Colors.white,
                                          ),
                                          labelStyle:
                                          const TextStyle(color: Colors.white),
                                          contentPadding:
                                          const EdgeInsets.symmetric(vertical: 5),

                                        ),
                                        obscureText: !_isNewPasswordVisible,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Polje ne smije biti prazno';
                                          }
                                          return null;
                                        },
                                        cursorColor: Colors.white,

                                        style:
                                            const TextStyle(color: Colors.white),
                                        onChanged: (_) {
                                          _changePasswordFormKey.currentState?.validate();
                                        },


                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      TextFormField(
                                        controller: _passwordPotvrdaController,

                                        cursorColor: Colors.white,
                                        decoration: InputDecoration(
                                          labelText: "Password potvrda",
                                          prefixIcon: const Icon(
                                            Icons.password_sharp,
                                            color: Colors.white,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _isConfirmPasswordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _isConfirmPasswordVisible  = !_isConfirmPasswordVisible ;
                                              });
                                            },
                                            color: Colors.white,
                                          ),
                                          labelStyle:
                                              const TextStyle(color: Colors.white),
                                          contentPadding:
                                              const EdgeInsets.symmetric(vertical: 5),

                                        ),
                                        style:
                                            const TextStyle(color: Colors.white),
                                        onChanged: (_) {
                                          _changePasswordFormKey.currentState?.validate();

                                        },
                                        obscureText: !_isConfirmPasswordVisible ,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Polje ne smije biti prazno';
                                          }
                                          if (value != _noviPasswordController.text) {
                                            return 'Lozinke se ne podudaraju';
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(
                                        height: 40,
                                      ),
                                      ElevatedButton(
                                        onPressed: registerUser,
                                        child: const Text(
                                          "Register",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isSignUpMode)
                GestureDetector(
                  onTap: () {
                    _imeController.clear();
                    _prezimeController.clear();
                    _emailController.clear();
                    _telefonController.clear();
                    _korisnickoImeController.clear();
                    _noviPasswordController.clear();
                    _passwordPotvrdaController.clear();
                    setState(() {
                      _isSignUpMode = false;
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.arrow_back, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        'Back to Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              RichText(
                text: TextSpan(
                  text: _isSignUpMode ? "" : "Nemate profil? Kreirajte ga  ",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  children: [
                    if (!_isSignUpMode)
                      TextSpan(
                        text: "ovdje",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              _isSignUpMode = true;
                            });
                          },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void registerUser() async {
    if (!_changePasswordFormKey.currentState!.validate()) {
      return;
    }

    if (_imeController.text.isEmpty ||
        _prezimeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telefonController.text.isEmpty ||
        _korisnickoImeController.text.isEmpty ||
        _noviPasswordController.text.isEmpty ||
        _passwordPotvrdaController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Greška"),
          content: const Text("Molimo popunite sva polja."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await _korisniciProvider.registerUser(
        ime: _imeController.text,
        prezime: _prezimeController.text,
        email: _emailController.text,
        telefon: _telefonController.text,
        korisnickoIme: _korisnickoImeController.text,
        password: _noviPasswordController.text,
        passwordPotvrda: _passwordPotvrdaController.text,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          const Duration duration = Duration(seconds: 2);

          return AlertDialog(
            title: const Text("Uspješno ste kreirali nalog!"),
            content: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: duration,
              builder: (BuildContext context, double value, Widget? child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 50 * value,
                      height: 50 * value,
                      child: const CircularProgressIndicator(
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.blue,
                        ),
                      ),
                    ),
                    if (value == 1)
                      const Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 50,
                      ),
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _imeController.clear();
                  _prezimeController.clear();
                  _emailController.clear();
                  _telefonController.clear();
                  _korisnickoImeController.clear();
                  _noviPasswordController.clear();
                  _passwordPotvrdaController.clear();
                  Navigator.pop(context);
                  setState(() {
                    _isSignUpMode = false;
                  });
                },
                child: const Text("U redu"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (e.toString().contains('Korisnik sa istim korisničkim imenom već postoji')) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Greška"),
            content: const Text("Došlo je do greške pri registraciji. Pokušajte ponovno."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );

      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text("Greška"),
            content: const Text("Korisnik sa istim korisničkim imenom već postoji."),
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}
