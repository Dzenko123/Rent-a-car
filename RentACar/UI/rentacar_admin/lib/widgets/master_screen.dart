import 'package:flutter/material.dart';
import 'package:rentacar_admin/main.dart';
import 'package:rentacar_admin/screens/cijene_po_vremenskom_periodu_screen.dart';
import 'package:rentacar_admin/screens/grad_dodatneUsluge_screen.dart';
import 'package:rentacar_admin/screens/izvjestaj_screen.dart';
import 'package:rentacar_admin/screens/kontakt_screen.dart';
import 'package:rentacar_admin/screens/korisnici_screen.dart';
import 'package:rentacar_admin/screens/profil_screen.dart';
import 'package:rentacar_admin/screens/recenzije_screen.dart';
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
              title: const Text("Cijene vozila po periodima"),
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
              title: const Text("Recenzije"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RecenzijeScreen(),
                  ),
                );
              },
            ), ListTile(
              title: const Text("Pregledi vozila"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VoziloPregledScreen(),
                  ),
                );
              },
            ),  ListTile(
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
              title: const Text("Izvjestaj"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  IzvjestajiPage(),
                  ),
                );
              },
            ),ListTile(
              title: const Text("Profil"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  ProfilScreen(),
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
