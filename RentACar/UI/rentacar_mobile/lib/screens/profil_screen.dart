import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/korisnici.dart';

class ProfilScreen extends StatefulWidget {
  final Korisnici? korisnik;
  const ProfilScreen({Key? key, this.korisnik}) : super(key: key);

  @override
  _ProfilScreenState createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uredite svoj profil'),
      ),
    );
  }
}
