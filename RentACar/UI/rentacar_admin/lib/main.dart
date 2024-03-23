import 'package:flutter/material.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LayoutExamples(),
    );
  }
}

class MyAppBar extends StatelessWidget {
  String title;
  MyAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;
  void _incrementCounter() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Pritisnuo si: $_count puta'),
      ElevatedButton(onPressed: _incrementCounter, child: Text("Inkrement++")),
      ElevatedButton(onPressed: _incrementCounter, child: Text("Inkrement++"))
    ]);
  }
}

class LayoutExamples extends StatelessWidget {
  const LayoutExamples({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 150,
          color: Colors.red,
          child: Center(
              child: Container(
            height: 100,
            color: Colors.blue,
            child: Text("Primjer"),
            alignment: Alignment.center,
          )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [Text("1"), Text("2"), Text("3")],
        ),
        Container(
          height: 150,
          color: Colors.red,
          child: Text("Kontejner"),
          alignment: Alignment.center,
        )
      ],
    );
  }
}

class GreenTheme {
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: Colors.blue,
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.blue,
      ),
      scaffoldBackgroundColor: Colors.blue[50],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue,
        textTheme: ButtonTextTheme.primary,
      ),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RS II Material App',
      theme: GreenTheme.getTheme(),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  late VozilaProvider _vozilaProvider;

  @override
  Widget build(BuildContext context) {
    _vozilaProvider = context.read<VozilaProvider>();
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  // Image.network(
                  //     "https://www.fit.ba/content/public/images/og-image.jpg",
                  Image.asset("assets/images/fit.jpg", height: 100, width: 100),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Username", prefixIcon: Icon(Icons.email)),
                    controller: _usernameController,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.password)),
                    controller: _passwordController,
                  ),
                  SizedBox(
                    height: 56,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var username = _usernameController.text;
                      var password = _passwordController.text;
                      print("Login uspješan $username $password");

                      Authorization.username = username;
                      Authorization.password = password;

                      try {
                        await _vozilaProvider.get();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const VozilaListScreen(),
                          ),
                        );
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"))
                                  ],
                                ));
                      }
                    },
                    child: Text("Login"),
                  )
                ]),
              ),
            ),
          ),
        ));
  }
}
