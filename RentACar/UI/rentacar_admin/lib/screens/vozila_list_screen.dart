import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/vozila_detail_screen.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class VozilaListScreen extends StatefulWidget {
  const VozilaListScreen({super.key});

  @override
  State<VozilaListScreen> createState() => _VozilaListScreenState();
}

class _VozilaListScreenState extends State<VozilaListScreen> {
  late VozilaProvider _vozilaProvider;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _vozilaProvider = context.read<VozilaProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
        title_widget: Text("Vozila list"),
        child: Container(
            child: Column(
          children: [
            Text("test"),
            SizedBox(
              height: 8,
            ),
            ElevatedButton(
              onPressed: () async {
                print("Login uspješan");
                //Navigator.of(context).pop();

                var data = await _vozilaProvider.get();
                print("data: ${data['result'][0]['godinaProizvodnje']}");
              },
              child: Text("Login"),
            )
          ],
        )));
  }
}
