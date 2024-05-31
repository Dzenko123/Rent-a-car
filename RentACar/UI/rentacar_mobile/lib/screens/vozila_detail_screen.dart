import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/gorivo_provider.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/vozilo_pregled_screen.dart';
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

  late VozilaProvider _vozilaProvider;
  late TipVozilaProvider _tipVozilaProvider;
  late GorivoProvider _gorivoProvider;

  SearchResult<TipVozila>? tipVozilaResult;
  SearchResult<Vozilo>? voziloResult;
  SearchResult<Gorivo>? gorivoResult;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'godinaProizvodnje': widget.vozilo?.godinaProizvodnje.toString(),
      'cijena': widget.vozilo?.cijena.toString(),
      'tipVozilaId': widget.vozilo?.tipVozilaId.toString(),
      'gorivoId': widget.vozilo?.gorivoId.toString(),
      'kilometraza': widget.vozilo?.kilometraza.toString(),
      'stateMachine': widget.vozilo?.stateMachine,
      'marka': widget.vozilo?.marka,
      'model': widget.vozilo?.model,
      'slika': widget.vozilo?.slika,
    };
    _tipVozilaProvider = context.read<TipVozilaProvider>();
    _vozilaProvider = context.read<VozilaProvider>();
    _gorivoProvider = context.read<GorivoProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    tipVozilaResult = await _tipVozilaProvider.get();
    voziloResult = await _vozilaProvider.get();
    gorivoResult = await _gorivoProvider.get();
    setState(() {
      isLoading = false;
    });

    //print(tipVozilaResult);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title:
          'Pregledate model i marku: ${widget.vozilo?.model}, ${widget.vozilo?.marka}',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Vozilo Detail'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildImagePreview(),
                      const SizedBox(height: 20),
                      isLoading ? Container() : _buildForm(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (widget.vozilo != null && widget.vozilo!.slika != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 160,
          width: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              base64Decode(widget.vozilo!.slika!),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VoziloPregledScreen(vozilo: widget.vozilo),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF000000),
                    Color(0xFF333333),
                    Color(0xFF555555),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Container(
                constraints:
                    const BoxConstraints(maxWidth: 100.0, minHeight: 36.0),
                alignment: Alignment.center,
                child: const Text(
                  "Pregledaj",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Pogledajte kada je ovo vozilo slobodno za rezervaciju!',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Detalji vozila',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Godina proizvodnje",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 24, 66, 139)),
                    prefixIcon: const Icon(Icons.calendar_month_outlined,
                        color: Color.fromARGB(255, 24, 66, 139)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "godinaProizvodnje",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Cijena",
                    labelStyle:
                        const TextStyle(color: Color.fromARGB(255, 6, 77, 6)),
                    prefixIcon: const Icon(Icons.attach_money_outlined,
                        color: Color.fromARGB(255, 6, 77, 6)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.green),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "cijena",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Model",
                    labelStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.car_crash_outlined,
                        color: Color.fromARGB(206, 0, 0, 0)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "model",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Marka",
                    labelStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.car_crash_outlined,
                        color: Color.fromARGB(206, 0, 0, 0)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "marka",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Kilometraža",
                    labelStyle: const TextStyle(
                        color: Color.fromARGB(255, 172, 155, 3)),
                    prefixIcon: const Icon(Icons.speed,
                        color: Color.fromARGB(255, 172, 155, 3)),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 172, 155, 3)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "kilometraza",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  readOnly: true,
                  initialValue:
                      gorivoResult != null && gorivoResult!.result.isNotEmpty
                          ? gorivoResult!.result
                              .firstWhere((item) =>
                                  item.gorivoId.toString() ==
                                  _initialValue['gorivoId'])
                              .tip
                          : null,
                  decoration: InputDecoration(
                    labelText: 'Gorivo',
                    labelStyle: const TextStyle(color: Colors.red),
                    prefixIcon: const Icon(
                      Icons.local_gas_station,
                      color: Colors.red,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(129, 160, 17, 7)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                readOnly: true,
                initialValue: tipVozilaResult != null &&
                        tipVozilaResult!.result.isNotEmpty
                    ? tipVozilaResult!.result
                        .firstWhere((item) =>
                            item.tipVozilaId.toString() ==
                            _initialValue['tipVozilaId'])
                        .tip
                    : null,
                decoration: InputDecoration(
                  labelText: 'Tip vozila',
                  prefixIcon: const Icon(Icons.directions_car),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
              ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'opis',
                  initialValue: tipVozilaResult != null &&
                          tipVozilaResult!.result.isNotEmpty
                      ? tipVozilaResult!.result
                          .firstWhereOrNull((item) =>
                              item.tipVozilaId.toString() ==
                              _initialValue['tipVozilaId'])
                          ?.opis
                      : null,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Opis',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 15.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
