import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
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
  SearchResult<TipVozila>? tipVozilaResult;
  SearchResult<Vozilo>? voziloResult;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'godinaProizvodnje': widget.vozilo?.godinaProizvodnje.toString(),
      'cijena': widget.vozilo?.cijena.toString(),
      'tipVozilaId': widget.vozilo?.tipVozilaId.toString(),
      'kilometraza': widget.vozilo?.kilometraza.toString(),
      'stateMachine': widget.vozilo?.stateMachine,
      'gorivo': widget.vozilo?.gorivo,
      'marka': widget.vozilo?.marka,
      'model': widget.vozilo?.model,
      'slika': widget.vozilo?.slika,
    };
    _tipVozilaProvider = context.read<TipVozilaProvider>();
    _vozilaProvider = context.read<VozilaProvider>();

    initForm();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future initForm() async {
    tipVozilaResult = await _tipVozilaProvider.get();
    voziloResult = await _vozilaProvider.get();

    setState(() {
      isLoading = false;
    });

    //print(tipVozilaResult);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isLoading ? Container() : _buildForm(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            _buildImagePreview(),
          ],
        ),
      ),
      title: this.widget.vozilo != null
          ? '${this.widget.vozilo?.voziloId}, ${this.widget.vozilo?.godinaProizvodnje}'
          : "Vozila details",
    );
  }

  Widget _buildImagePreview() {
    if (widget.vozilo != null && widget.vozilo!.slika != null) {
      return Center(
        child: Container(
          height: 500,
          width: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: MemoryImage(base64Decode(widget.vozilo!.slika!)),
              fit: BoxFit.contain,
            ),
          ),
          alignment: Alignment.center,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalji vozila',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                    labelText: "Godina proizvodnje",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  name: "godinaProizvodnje",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                    labelText: "Cijena",
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  name: "cijena",
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                    labelText: "Model",
                    prefixIcon: Icon(Icons.car_crash_outlined),
                  ),
                  name: "model",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                    labelText: "Marka",
                    prefixIcon: Icon(Icons.car_rental),
                  ),
                  name: "marka",
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  decoration: const InputDecoration(
                    labelText: "KM",
                    prefixIcon: Icon(Icons.speed),
                  ),
                  name: "kilometraza",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: "gorivo",
                  decoration: InputDecoration(
                    labelText: 'Gorivo',
                    suffix: IconButton(
                      icon: const Icon(Icons.local_gas_station),
                      onPressed: () {
                        _formKey.currentState?.fields['voziloId']
                            ?.didChange(null);
                      },
                    ),
                    hintText: 'Odaberi tip goriva',
                  ),
                  items: voziloResult?.result
                          .map((item) => item.gorivo)
                          .toSet()
                          .map((gorivo) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: gorivo,
                                child: Text(gorivo ?? ""),
                              ))
                          .toList() ??
                      [],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderDropdown<String>(
                  name: 'tipVozilaId',
                  decoration: InputDecoration(
                    labelText: 'Tip vozila',
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState?.fields['tipVozilaId']
                            ?.didChange(null);
                      },
                    ),
                    hintText: 'Odaberi tip vozila',
                  ),
                  items: tipVozilaResult?.result
                          .map((item) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: item.tipVozilaId.toString(),
                                child: Text(item.tip ?? ""),
                              ))
                          .toList() ??
                      [],
                  onChanged: (newValue) {
                    setState(() {
                      var selectedTip = tipVozilaResult?.result.firstWhere(
                          (item) => item.tipVozilaId.toString() == newValue,
                          orElse: () => TipVozila(null, null,
                              null));
                      _formKey.currentState?.fields['opis']
                          ?.didChange(selectedTip?.opis ?? '');
                    });
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderTextField(
                  name: 'opis',
                  initialValue: tipVozilaResult != null &&
                          tipVozilaResult!.result != null &&
                          tipVozilaResult!.result!.isNotEmpty
                      ? tipVozilaResult!.result!
                          .firstWhere(
                              (item) =>
                                  item.tipVozilaId.toString() ==
                                  _initialValue['tipVozilaId'],
                              orElse: () => TipVozila(null, null, null))
                          .opis
                      : null,
                  decoration: InputDecoration(
                    labelText: 'Opis',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TipOpisScreen(tipVozila: null),
                    ),
                  );

                  if (result == true) {
                    setState(() {
                      isLoading = true;
                    });
                    initForm();
                  }
                },
                child: const Text("Dodaj tip/opis"),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: FormBuilderField(
                  name: 'imageId',
                  builder: ((field) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        label: Text('Odaberite sliku'),
                        errorText: field.errorText,
                      ),
                      child: _image != null
                          ? Row(
                              children: [
                                Expanded(
                                  child: Image.file(
                                    _image!,
                                    //fit: BoxFit.cover,
                                    height: 150,
                                    width: 150,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                ),
                              ],
                            )
                          : ListTile(
                              leading: Icon(Icons.photo),
                              title: Text("Select image"),
                              trailing: Icon(Icons.file_upload),
                              onTap: getImage,
                            ),
                    );
                  }),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.saveAndValidate();
                  print(_formKey.currentState?.value);
                  var request = new Map.from(_formKey.currentState!.value);
                  print("Opis: ${_formKey.currentState!.value['opis']}");
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
                      SnackBar(
                        content: Text('Podaci su uspješno sačuvani!'),
                      ),
                    );
                  } on Exception catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text("Error"),
                        content: Text(e.toString()),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
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
                    gradient: LinearGradient(
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
                        BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                    alignment: Alignment.center,
                    child: Text(
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
