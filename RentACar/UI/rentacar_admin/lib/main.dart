import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/utils/util.dart';
import './screens/vozila_list_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => VozilaProvider()),
    ChangeNotifierProvider(create: (_) => TipVozilaProvider())
  ], child: const MyMaterialApp()));
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS II Material App',
      home: LoginPage(),
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: UnderlineInputBorder(
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
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
        decoration: BoxDecoration(
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
                  constraints: BoxConstraints(maxHeight: 300, maxWidth: 350),
                  child: Card(
                    elevation: 5,
                    color: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      side: BorderSide(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
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
                                decoration: InputDecoration(
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
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              TextField(
                                cursorColor: Colors.white,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: Colors.white,
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
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
                                style: TextStyle(color: Colors.white),
                                obscureText: _isPasswordObscured,
                              ),
                              SizedBox(
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
                                            const VozilaListScreen(),
                                      ),
                                    );
                                  } on Exception catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: Text("Error"),
                                        content: Text(e.toString()),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text("OK"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                child: Text(
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
