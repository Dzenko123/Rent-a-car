import 'package:flutter/material.dart';
import 'package:rentacar_admin/main.dart';
import 'package:rentacar_admin/screens/vozila_detail_screen.dart';
import 'package:rentacar_admin/screens/vozila_list_screen.dart';

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
              title: Text("Back"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Vozila"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const VozilaListScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text("Detalji"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const VozilaDetailScreen(),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: widget.child!,
    );
  }
}
