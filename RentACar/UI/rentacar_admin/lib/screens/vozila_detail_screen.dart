import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
import 'package:rentacar_admin/screens/gorivo_screen.dart';
import 'package:rentacar_admin/screens/tip_opis_screen.dart';
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
      'motor': widget.vozilo?.motor,
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
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.vozilo != null
          ? 'Uređujete model i marku: ${widget.vozilo?.model}, ${widget.vozilo?.marka}'
          : "Dodajte novo vozilo",
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading ? Container() : _buildForm(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 20),
            _buildImagePreview(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (widget.vozilo != null && widget.vozilo!.slika != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 300,
          width: 520,
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
                    hintText: "Unesite godinu proizvodnje",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "godinaProizvodnje",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  decoration: InputDecoration(
                    labelText: "Motor",
                    labelStyle:
                        const TextStyle(color: Color.fromARGB(255, 6, 77, 6)),
                    prefixIcon: const Icon(Icons.miscellaneous_services,
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
                    hintText: "Unesite snagu motora",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "motor",
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
                    hintText: "Unesite model",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "model",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
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
                    hintText: "Unesite marku",
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
                    hintText: "Unesite kilometražu",
                    hintStyle: const TextStyle(color: Colors.grey),
                  ),
                  name: "kilometraza",
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: "gorivoId",
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
                    hintText: 'Odaberi tip goriva',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _formKey.currentState?.fields['gorivoId']
                            ?.didChange(null);
                      },
                    ),
                  ),
                  items: gorivoResult?.result.map((item) {
                        return DropdownMenuItem<String>(
                          value: item.gorivoId.toString(),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.tip ?? "",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _editGorivo(item);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever_sharp,
                                    color: Colors.red),
                                onPressed: () {
                                  _deleteGorivo(item);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList() ??
                      [],
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: "tipVozilaId",
                  decoration: InputDecoration(
                    labelText: 'Tip vozila',
                    prefixIcon: const Icon(Icons.directions_car),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal: 15.0,
                    ),
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
                    hintText: 'Odaberi tip vozila',
                    hintStyle: const TextStyle(color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _formKey.currentState?.fields['tipVozilaId']
                            ?.didChange(null);
                      },
                    ),
                  ),
                  items: tipVozilaResult?.result.map((tip) {
                        return DropdownMenuItem<String>(
                          value: tip.tipVozilaId.toString(),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  tip.tip ?? "",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _editTipVozila(tip);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_forever_sharp,
                                    color: Colors.red),
                                onPressed: () {
                                  _deleteTipVozila(tip);
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList() ??
                      [],
                  onChanged: (newValue) {
                    setState(() {
                      var selectedTip = tipVozilaResult?.result.firstWhere(
                        (tip) => tip.tipVozilaId.toString() == newValue,
                        orElse: () => TipVozila(null, null, null),
                      );
                      _formKey.currentState?.fields['opis']
                          ?.didChange(selectedTip?.opis ?? '');
                    });
                  },
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
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
                          .firstWhere(
                              (item) =>
                                  item.tipVozilaId.toString() ==
                                  _initialValue['tipVozilaId'],
                              orElse: () => TipVozila(null, null, null))
                          .opis
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          const TipOpisScreen(tipVozila: null),
                    ),
                  );

                  if (result == true) {
                    setState(() {
                      isLoading = true;
                    });
                    initForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
                child: const Text("Dodaj tip/opis"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GorivoScreen(gorivo: null),
                    ),
                  );

                  if (result == true) {
                    setState(() {
                      isLoading = true;
                    });
                    initForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
                child: const Text("Dodaj tip goriva"),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: FormBuilderField(
                  name: 'imageId',
                  builder: ((field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Odaberite novu sliku',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 50.0, horizontal: 15.0),
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
                        errorText: field.errorText,
                      ),
                      child: _image != null
                          ? Row(
                              children: [
                                Expanded(
                                  child: Image.file(
                                    _image!,
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                ),
                              ],
                            )
                          : ListTile(
                              leading: const Icon(Icons.photo),
                              title: const Text("Odaberi sliku"),
                              trailing: const Icon(Icons.file_upload),
                              onTap: getImage,
                            ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.saveAndValidate();
                  var request = Map.from(_formKey.currentState!.value);
                  request['opis'] = _formKey.currentState!.value['opis'];

                  if (_base64Image != null) {
                    request['slika'] = _base64Image;
                  } else {
                    request['slika'] = widget.vozilo?.slika;
                  }
                  request['model'] = _formKey.currentState!.value['model'];

                  try {
                    if (widget.vozilo == null) {
                      await _vozilaProvider.insert(request);
                    } else {
                      await _vozilaProvider.update(
                          widget.vozilo!.voziloId!, request);
                    }
                    if (_base64Image != null) {
                      setState(() {
                        widget.vozilo?.slika = _base64Image;
                      });
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Podaci su uspješno sačuvani!'),
                      ),
                    );
                  } on Exception catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("Error"),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
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
                        const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Sačuvaj",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _refreshGorivoData() async {
    gorivoResult = await _gorivoProvider.get();
    setState(() {
      isLoading = false;
    });
    initForm();
  }

  void _editGorivo(Gorivo gorivo) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final _formKey = GlobalKey<FormState>();
    bool isTipFieldEmpty = gorivo.tip == null || gorivo.tip!.isEmpty;

    var updatedGorivo = await showDialog(
      context: context,
      builder: (context) {
        var editedGorivo = Gorivo.fromJson(gorivo.toJson());
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Uredi tip goriva'),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  initialValue: gorivo.tip,
                  onChanged: (value) {
                    setState(() {
                      isTipFieldEmpty = value.isEmpty;
                      editedGorivo.tip = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje je obavezno';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Tip goriva',
                    errorText: isTipFieldEmpty ? 'Polje je obavezno' : null,
                  ),
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await _gorivoProvider.update(
                            gorivo.gorivoId, editedGorivo.toJson());
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                              content: Text('Tip goriva je uspješno ažuriran')),
                        );
                        Navigator.pop(context, editedGorivo);
                      } catch (e) {
                        scaffoldMessenger.showSnackBar(
                          SnackBar(content: Text('Došlo je do pogreške: $e')),
                        );
                      }
                    }
                  },
                  child: Text('Spremi'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Odustani'),
                ),
              ],
            );
          },
        );
      },
    );

    if (updatedGorivo != null) {
      setState(() {
        gorivoResult?.result.forEach((item) {
          if (item.gorivoId == updatedGorivo.gorivoId) {
            item.tip = updatedGorivo.tip;
          }
        });
      });
      await _refreshGorivoData();
    }
  }

  void _deleteGorivo(Gorivo gorivo) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var deletedGorivo = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Brisanje tipa goriva'),
          content:
              Text('Jeste li sigurni da želite izbrisati ovaj tip goriva?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await _gorivoProvider.delete(gorivo.gorivoId);

                  setState(() {
                    gorivoResult?.result.removeWhere(
                        (item) => item.gorivoId == gorivo.gorivoId);
                  });

                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Tip goriva je uspješno izbrisan')),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Došlo je do pogreške: $e')),
                  );
                }
              },
              child: Text('Obriši'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Odustani'),
            ),
          ],
        );
      },
    );
    if (deletedGorivo != null) {
      setState(() {
        gorivoResult?.result.forEach((item) {
          if (item.gorivoId == deletedGorivo.gorivoId) {
            item.tip = deletedGorivo.tip;
          }
        });
      });
      await _refreshGorivoData();
    }
  }

  Future<void> _refreshTipVozilaData() async {
    tipVozilaResult = await _tipVozilaProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  void _editTipVozila(TipVozila tipVozila) {
    final _formKey = GlobalKey<FormState>();
    bool isTipFieldEmpty = tipVozila.tip == null || tipVozila.tip!.isEmpty;
    bool isOpisFieldEmpty = tipVozila.opis == null || tipVozila.opis!.isEmpty;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Uredi tip vozila'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      initialValue: tipVozila.tip,
                      onChanged: (value) {
                        setState(() {
                          isTipFieldEmpty = value.isEmpty;
                          tipVozila.tip = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Polje je obavezno';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Tip vozila',
                        errorText: isTipFieldEmpty ? 'Polje je obavezno' : null,
                      ),
                    ),
                    TextFormField(
                      initialValue: tipVozila.opis,
                      onChanged: (value) {
                        setState(() {
                          isOpisFieldEmpty = value.isEmpty;
                          tipVozila.opis = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Polje je obavezno';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Opis',
                        errorText:
                            isOpisFieldEmpty ? 'Polje je obavezno' : null,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateTipVozila(tipVozila);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Spremi'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Odustani'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _updateTipVozila(TipVozila tipVozila) async {
    if (tipVozila.tip == null ||
        tipVozila.tip!.isEmpty ||
        tipVozila.opis == null ||
        tipVozila.opis!.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Greška'),
            content: Text('Morate popuniti sva polja.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      try {
        await _tipVozilaProvider.update(tipVozila.tipVozilaId!, {
          'Tip': tipVozila.tip,
          'Opis': tipVozila.opis,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tip vozila je uspješno ažuriran')),
        );
        setState(() {
          isLoading = true;
        });
        await _refreshTipVozilaData();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Došlo je do pogreške: $e')),
        );
      }
    }
  }

  void _deleteTipVozila(TipVozila tipVozila) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var deletedTipVozila = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Brisanje tipa vozila'),
          content:
              Text('Jeste li sigurni da želite izbrisati ovaj tip vozila?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                try {
                  await _tipVozilaProvider.delete(tipVozila.tipVozilaId!);

                  setState(() {
                    tipVozilaResult?.result.removeWhere(
                        (item) => item.tipVozilaId == tipVozila.tipVozilaId);
                  });

                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Tip vozila je uspješno izbrisan')),
                  );
                } catch (e) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Došlo je do pogreške: $e')),
                  );
                }
              },
              child: Text('Obriši'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Odustani'),
            ),
          ],
        );
      },
    );

    if (deletedTipVozila != null) {
      setState(() {
        tipVozilaResult?.result.forEach((item) {
          if (item.tipVozilaId == deletedTipVozila.tipVozilaId) {
            item.tip = deletedTipVozila.tip;
          }
        });
      });
      await _refreshTipVozilaData();
    }
  }

  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _image = File(result.files.single.path!);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }
}
