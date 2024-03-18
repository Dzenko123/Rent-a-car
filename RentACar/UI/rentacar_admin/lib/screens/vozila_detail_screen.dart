import 'package:flutter/material.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class VozilaDetailScreen extends StatefulWidget {
  const VozilaDetailScreen({super.key});

  @override
  State<VozilaDetailScreen> createState() => _VozilaDetailScreenState();
}

class _VozilaDetailScreenState extends State<VozilaDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(child: Text("Detalji"), title: "Vozila details");
  }
}
