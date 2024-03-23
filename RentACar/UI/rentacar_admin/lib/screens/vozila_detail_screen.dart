import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class VozilaDetailScreen extends StatefulWidget {
  Vozilo? vozilo;

  VozilaDetailScreen({super.key, this.vozilo});

  @override
  State<VozilaDetailScreen> createState() => _VozilaDetailScreenState();
}

class _VozilaDetailScreenState extends State<VozilaDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'godinaProizvodnje': widget.vozilo?.godinaProizvodnje.toString(),
      'cijena': widget.vozilo?.cijena.toString(),
      'dostupan':widget.vozilo?.dostupan.toString(),
      'stateMachine':widget.vozilo?.stateMachine.toString()
    };
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // if (widget.vozilo != null) {
    //   setState(() {
    //     _formKey.currentState?.patchValue(
    //         {'godinaProizvodnje': widget.vozilo?.godinaProizvodnje});
    //   });
    //}
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: _buildForm(),
      title: this.widget.vozilo != null
          ? '${this.widget.vozilo?.voziloId}, ${this.widget.vozilo?.godinaProizvodnje}'
          : "Vozila details",
    );
  }

  FormBuilder _buildForm() {
    return FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    decoration:
                        const InputDecoration(labelText: "Godina proizvodnje"),
                    name: "godinaProizvodnje",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Cijena"),
                    name: "cijena",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "Dostupan"),
                    name: "dostupan",
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: FormBuilderTextField(
                    decoration: const InputDecoration(labelText: "State machine"),
                    name: "stateMachine",
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
