import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class VozilaDetailScreen extends StatefulWidget {
  Vozilo? vozilo;

  VozilaDetailScreen({super.key, this.vozilo});

  @override
  State<VozilaDetailScreen> createState() => _VozilaDetailScreenState();
}

class _VozilaDetailScreenState extends State<VozilaDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Text("Detalji"), 
      title: this.widget.vozilo != null ? '${this.widget.vozilo?.voziloId}, ${this.widget.vozilo?.godinaProizvodnje}' : "Vozila details",
    );
  }
}

