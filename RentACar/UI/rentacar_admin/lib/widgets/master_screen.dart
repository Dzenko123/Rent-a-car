import 'package:flutter/material.dart';
import 'package:rentacar_admin/main.dart';
import 'package:rentacar_admin/screens/cijene_po_vremenskom_periodu_screen.dart';
import 'package:rentacar_admin/screens/kontakt_screen.dart';
import 'package:rentacar_admin/screens/korisnici_screen.dart';
import 'package:rentacar_admin/screens/rezervacija_screen.dart';
import 'package:rentacar_admin/screens/vozila_detail_screen.dart';
import 'package:rentacar_admin/screens/vozila_list_screen.dart';
import 'package:rentacar_admin/screens/vozilo_pregled_screen.dart';

class MasterScreenWidget extends StatefulWidget {
  Widget? child;
  String? title;
  Widget? title_widget;

  MasterScreenWidget({this.child, this.title, this.title_widget, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title_widget ?? Text(widget.title ?? ""),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Back"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Vozila"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VozilaListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Detalji"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VozilaDetailScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Korisnici"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => KorisniciListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Kontakt"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => KontaktScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Cijene po periodu"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CijenePoVremenskomPerioduScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Rezervacije"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RezervacijaScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text("Kalendar rezervacija"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VoziloPregledScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
