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
import 'package:form_builder_validators/form_builder_validators.dart';

class VozilaDetailScreen extends StatefulWidget {
  Vozilo? vozilo;

  VozilaDetailScreen({super.key, this.vozilo});

  @override
  State<VozilaDetailScreen> createState() => _VozilaDetailScreenState();
}

class _VozilaDetailScreenState extends State<VozilaDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  bool _isTipVozilaSelected = false;

  late VozilaProvider _vozilaProvider;
  late TipVozilaProvider _tipVozilaProvider;
  late GorivoProvider _gorivoProvider;
  bool _isDropdownOpened = false;
  TextEditingController _selectedItemController = TextEditingController();
  bool _isGorivoSelected = false;
  SearchResult<TipVozila>? tipVozilaResult;
  SearchResult<Vozilo>? voziloResult;
  SearchResult<Gorivo>? gorivoResult;
  String? _lastSelectedGorivoId;
  String? _lastSelectedTipVozilaId;
  bool _isSlikaSelected = false;

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
    _lastSelectedGorivoId = widget.vozilo?.gorivoId.toString();
    _lastSelectedTipVozilaId = widget.vozilo?.tipVozilaId.toString();
    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> initForm() async {
    setState(() {
      isLoading = true;
    });

    try {
      tipVozilaResult = await _tipVozilaProvider.get();
      voziloResult = await _vozilaProvider.get();
      gorivoResult = await _gorivoProvider.get();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
                  name: "godinaProizvodnje",
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
                  style: const TextStyle(fontSize: 16.0),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Ovo polje je obavezno.',
                    ),
                    FormBuilderValidators.numeric(
                      errorText: 'Molimo unesite numeričku vrijednost.',
                    ),
                    FormBuilderValidators.min(
                      1886,
                      errorText: 'Godina mora biti najmanje 1886.',
                    ),
                    FormBuilderValidators.max(
                      DateTime.now().year,
                      errorText: 'Godina ne može biti veća od trenutne godine.',
                    ),
                  ]),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  name: "motor",
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
                  style: const TextStyle(fontSize: 16.0),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Ovo polje je obavezno.',
                    ),
                    FormBuilderValidators.match(
                      r'^\d+\.\d$',
                      errorText:
                          'Format mora biti npr. "1.9" ili "2.0" i slično.',
                    ),
                  ]),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: "model",
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
                  style: const TextStyle(fontSize: 16.0),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.required(
                    errorText: 'Ovo polje je obavezno.',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  name: "marka",
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
                  style: const TextStyle(fontSize: 16.0),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.required(
                    errorText: 'Ovo polje je obavezno.',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: "kilometraza",
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
                  style: const TextStyle(fontSize: 16.0),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Ovo polje je obavezno.',
                    ),
                    FormBuilderValidators.numeric(
                      errorText: 'Molimo unesite numeričku vrijednost.',
                    ),
                    FormBuilderValidators.min(
                      0.1,
                      errorText: 'Kilometraža mora biti veća od 0.',
                    ),
                  ]),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: PopupMenuButton<String>(
                  tooltip: 'Prikaže dostupne vrste goriva',
                  initialValue: _lastSelectedGorivoId,
                  onSelected: (newValue) {
                    setState(() {
                      _lastSelectedGorivoId = newValue;
                      _isGorivoSelected = true;
                      _formKey.currentState?.fields['gorivoId']
                          ?.didChange(newValue);
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return gorivoResult?.result.map((item) {
                          return PopupMenuItem<String>(
                            value: item.gorivoId.toString(),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(item.tip ?? ""),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _editGorivo(
                                        item, context, _lastSelectedGorivoId);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_forever_sharp,
                                      color: Colors.red),
                                  onPressed: () {
                                    _deleteGorivo(
                                        item, context, _lastSelectedGorivoId);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList() ??
                        [];
                  },
                  child: FormBuilderField(
                    name: 'gorivoId',
                    validator: FormBuilderValidators.required(
                      errorText: 'Obavezno odabrati tip goriva!',
                    ),
                    builder: (field) => InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Gorivo',
                        labelStyle: const TextStyle(color: Colors.red),
                        prefixIcon: const Icon(Icons.local_gas_station,
                            color: Colors.red),
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
                            setState(() {
                              _lastSelectedGorivoId = null;
                              _formKey.currentState?.fields['gorivoId']
                                  ?.didChange(null);
                              _isGorivoSelected = false;
                            });
                          },
                        ),
                        errorText: _isGorivoSelected ? null : field.errorText,
                      ),
                      child: _lastSelectedGorivoId != null
                          ? Text(
                              gorivoResult?.result
                                      ?.firstWhere((element) =>
                                          element.gorivoId.toString() ==
                                          _lastSelectedGorivoId)
                                      ?.tip ??
                                  'Nepoznato',
                              style: TextStyle(color: Colors.black),
                            )
                          : Text(
                              'Odaberi tip goriva',
                              style: TextStyle(color: Colors.grey),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PopupMenuButton<String>(
                  tooltip: 'Prikaže dostupne tipove vozila',
                  initialValue: _lastSelectedTipVozilaId,
                  onSelected: (newValue) {
                    setState(() {
                      var selectedTip = tipVozilaResult?.result.firstWhere(
                        (tip) => tip.tipVozilaId.toString() == newValue,
                        orElse: () => TipVozila(null, null, null),
                      );
                      _formKey.currentState?.fields['tipVozilaId']
                          ?.didChange(newValue);
                      _formKey.currentState?.fields['opis']
                          ?.didChange(selectedTip?.opis ?? '');
                      _lastSelectedTipVozilaId = newValue;
                      _isTipVozilaSelected = true;
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    return tipVozilaResult?.result.map((tip) {
                          return PopupMenuItem<String>(
                            value: tip.tipVozilaId.toString(),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(tip.tip ?? ""),
                                ),
                                if (widget.vozilo == null ||
                                    tip.tipVozilaId.toString() !=
                                        _formKey.currentState
                                            ?.fields['tipVozilaId']?.value) ...[
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      _editTipVozila(tip, context);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_forever_sharp,
                                        color: Colors.red),
                                    onPressed: () {
                                      _deleteTipVozila(tip, context,
                                          _lastSelectedTipVozilaId);
                                    },
                                  ),
                                ],
                              ],
                            ),
                          );
                        }).toList() ??
                        [];
                  },
                  child: FormBuilderField(
                    name: 'tipVozilaId',
                    validator: FormBuilderValidators.required(
                      errorText: 'Obavezno odabrati tip vozila!',
                    ),
                    builder: (field) => InputDecorator(
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
                        hintText: 'Odaberi tip vozila',
                        hintStyle: const TextStyle(color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _lastSelectedTipVozilaId = null;
                              _formKey.currentState?.fields['tipVozilaId']
                                  ?.didChange(null);
                              _formKey.currentState?.fields['opis']
                                  ?.didChange('');
                              _isTipVozilaSelected = false;
                            });
                          },
                        ),
                        errorText: _lastSelectedTipVozilaId != null
                            ? null
                            : field.errorText,
                      ),
                      child: _lastSelectedTipVozilaId != null
                          ? Text(
                              tipVozilaResult?.result
                                      ?.firstWhere((element) =>
                                          element.tipVozilaId.toString() ==
                                          _lastSelectedTipVozilaId)
                                      ?.tip ??
                                  'Nepoznato',
                              style: TextStyle(color: Colors.black),
                            )
                          : Text(
                              'Odaberi tip vozila',
                              style: TextStyle(color: Colors.grey),
                            ),
                    ),
                  ),
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
                          tipVozilaResult!.result.isNotEmpty &&
                          _lastSelectedTipVozilaId != null
                      ? tipVozilaResult!.result
                          .firstWhere(
                              (item) =>
                                  item.tipVozilaId.toString() ==
                                  _lastSelectedTipVozilaId!,
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

                  if (result != null && result is TipVozila) {
                    setState(() {
                      int index = tipVozilaResult!.result.indexWhere(
                          (item) => item.tipVozilaId == result.tipVozilaId);
                      if (index != -1) {
                        tipVozilaResult!.result[index] = result;
                      } else {
                        tipVozilaResult!.result.add(result);
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                ),
                child: const Text("Dodaj tip vozila i opis"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const GorivoScreen(gorivo: null),
                    ),
                  );

                  if (result != null && result is Gorivo) {
                    setState(() {
                      int index = gorivoResult!.result.indexWhere(
                          (item) => item.gorivoId == result.gorivoId);
                      if (index != -1) {
                        gorivoResult!.result[index] = result;
                      } else {
                        gorivoResult!.result.add(result);
                      }
                    });
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
                  name: 'slika',
                  validator: (value) {
                    if (!_isSlikaSelected &&
                        _base64Image == null &&
                        widget.vozilo?.slika == null) {
                      return 'Obavezno odabrati novu sliku!';
                    }
                    return null;
                  },
                  builder: (field) {
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
                        errorText: _isSlikaSelected ? null : field.errorText,
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
                                      _base64Image = null;
                                      _isSlikaSelected = false;
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
                  },
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
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    var request = Map.from(_formKey.currentState!.value);
                    request['opis'] = _formKey.currentState!.value['opis'];

                    if (_base64Image != null) {
                      request['slika'] = _base64Image;
                    } else {
                      request['slika'] = widget.vozilo?.slika;
                    }

                    request['model'] = _formKey.currentState!.value['model'];
                    request['gorivoId'] = _lastSelectedGorivoId;
                    request['tipVozilaId'] = _lastSelectedTipVozilaId;

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
                      if (widget.vozilo == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Podaci su uspješno sačuvani!'),
                          ),
                        );
                        initForm();
                        setState(() {
                          _lastSelectedGorivoId = null;
                          _lastSelectedTipVozilaId = null;
                          _image = null;
                        });
                      } else if (widget.vozilo != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Podaci su uspješno sačuvani!'),
                          ),
                        );
                      }
                    } on Exception catch (e) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text("Greška"),
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
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Podaci nisu ispravno uneseni!'),
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

  void _editGorivo(
      Gorivo gorivo, BuildContext context, String? lastSelectedGorivoId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final _formKeyDialog = GlobalKey<FormState>();

    TextEditingController tipController =
        TextEditingController(text: gorivo.tip);

    var updatedGorivo = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Uredi tip goriva'),
          content: Form(
            key: _formKeyDialog,
            child: TextFormField(
              controller: tipController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Polje je obavezno';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Tip goriva',
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_formKeyDialog.currentState!.validate()) {
                  try {
                    await _gorivoProvider
                        .update(gorivo.gorivoId, {'tip': tipController.text});
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Tip goriva je uspješno ažuriran')),
                    );
                    Navigator.pop(context, tipController.text);
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text('Došlo je do pogreške: $e.'),
                          backgroundColor: Colors.red),
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

    if (updatedGorivo != null) {
      setState(() {
        gorivo.tip = updatedGorivo;
      });
      Navigator.pop(context);

      getGorivoFormBuilderState()
          .fields['gorivoId']
          ?.didChange(lastSelectedGorivoId);
    }
  }

  FormBuilderState getGorivoFormBuilderState() {
    final state = _formKey.currentState!;
    state.fields['gorivoId']?.didChange(_lastSelectedGorivoId);
    return state;
  }

  void _deleteGorivo(
      Gorivo gorivo, BuildContext context, String? lastSelectedGorivoId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Brisanje tipa goriva'),
          content:
              Text('Jeste li sigurni da želite izbrisati ovaj tip goriva?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context, true);
              },
              child: Text('Obriši'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Odustani'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _gorivoProvider.delete(gorivo.gorivoId);

        setState(() {
          gorivoResult?.result
              .removeWhere((item) => item.gorivoId == gorivo.gorivoId);
        });

        scaffoldMessenger.showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text('Tip goriva je uspješno izbrisan')),
        );

        Navigator.pop(context);

        _formKey.currentState?.fields['gorivoId']
            ?.didChange(lastSelectedGorivoId);
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                  'Došlo je do pogreške. Gorivo se ne može brisati jer neko od vozila koje ima ovaj tip goriva je rezervisano.')),
        );
      }
    }
  }

  Future<void> _refreshTipVozilaData() async {
    tipVozilaResult = await _tipVozilaProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  void _editTipVozila(TipVozila tipVozila, BuildContext context) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final _formKeyDialog = GlobalKey<FormState>();

    TextEditingController tipController =
        TextEditingController(text: tipVozila.tip);
    TextEditingController opisController =
        TextEditingController(text: tipVozila.opis);

    var updatedTipVozila = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Uredi tip vozila'),
          content: Form(
            key: _formKeyDialog,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: tipController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje je obavezno';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Tip vozila',
                  ),
                ),
                TextFormField(
                  controller: opisController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje je obavezno';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Opis',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_formKeyDialog.currentState!.validate()) {
                  try {
                    await _tipVozilaProvider.update(tipVozila.tipVozilaId!, {
                      'tip': tipController.text,
                      'opis': opisController.text,
                    });

                    tipVozila.tip = tipController.text;
                    tipVozila.opis = opisController.text;

                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Tip vozila je uspješno ažuriran')),
                    );
                    Navigator.pop(context, tipVozila);

                    _formKey.currentState?.fields['opis']
                        ?.didChange(opisController.text);
                  } catch (e) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Došlo je do pogreške: $e.')),
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

    if (updatedTipVozila != null) {
      setState(() {
        tipVozila.tip = updatedTipVozila.tip;
        tipVozila.opis = updatedTipVozila.opis;
      });

      Navigator.pop(context);

      _formKey.currentState?.fields['tipVozilaId']
          ?.didChange(tipVozila.tipVozilaId.toString());
    }
  }

  void _deleteTipVozila(TipVozila tipVozila, BuildContext context,
      String? lastSelectedTipVozilaId) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    var confirmed = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Brisanje tipa vozila'),
          content:
              Text('Jeste li sigurni da želite izbrisati ovaj tip vozila?'),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context, true);
              },
              child: Text('Obriši'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Odustani'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await _tipVozilaProvider.delete(tipVozila.tipVozilaId!);

        setState(() {
          tipVozilaResult?.result
              .removeWhere((item) => item.tipVozilaId == tipVozila.tipVozilaId);
        });

        scaffoldMessenger.showSnackBar(
          SnackBar(
              backgroundColor: Colors.green,
              content: Text('Tip vozila je uspješno izbrisan')),
        );

        Navigator.pop(context);

        _formKey.currentState?.fields['tipVozilaId']
            ?.didChange(lastSelectedTipVozilaId);
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                  'Došlo je do pogreške. Ovaj tip se ne može brisati jer neko od vozila koje je ovog tipa je rezervisano.')),
        );
      }
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
        _isSlikaSelected = true;
      });
    }
  }
}
