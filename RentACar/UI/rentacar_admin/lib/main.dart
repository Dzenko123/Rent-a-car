import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/providers/gorivo_provider.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/utils/util.dart';
import './screens/vozila_list_screen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1200, 800));
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => VozilaProvider()),
    ChangeNotifierProvider(create: (_) => TipVozilaProvider()),
    ChangeNotifierProvider(create: (_) => GorivoProvider())
  ], child: const MyMaterialApp()));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS II Material App',
      home: const LoginPage(),
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

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late VozilaProvider _vozilaProvider;
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    _vozilaProvider = context.read<VozilaProvider>();
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Welcome to login page.",
      //     style: TextStyle(
      //         fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13),
      //   ),
      //   backgroundColor: Color.fromARGB(255, 23, 22, 22),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/lambo.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 300, maxWidth: 350),
                  child: Card(
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
                          child: Column(
                            children: [
                              TextField(
                                cursorColor: Colors.white,
                                decoration: const InputDecoration(
                                  labelText: "Username",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                ),
                                controller: _usernameController,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextField(
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: const Icon(
                                    Icons.password,
                                    color: Colors.white,
                                  ),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 5),
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
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  var username = _usernameController.text;
                                  var password = _passwordController.text;
                                  Authorization.username = username;
                                  Authorization.password = password;

                                  try {
                                    await _vozilaProvider.get();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VozilaListScreen(),
                                      ),
                                    );
                                  } on Exception catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text("Error"),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.black),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
