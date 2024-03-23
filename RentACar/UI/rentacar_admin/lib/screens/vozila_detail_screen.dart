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
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'godinaProizvodnje': widget.vozilo?.godinaProizvodnje.toString(),
      'cijena': widget.vozilo?.cijena.toString(),
      'tipVozilaId': widget.vozilo?.tipVozilaId.toString()
    };
    _tipVozilaProvider = context.read<TipVozilaProvider>();
    _vozilaProvider = context.read<VozilaProvider>();

    initForm();
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

  Future initForm() async {
    tipVozilaResult = await _tipVozilaProvider.get();
    setState(() {
      isLoading = false;
    });

    print(tipVozilaResult);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      // ignore: sort_child_properties_last
      child: Column(
        children: [
          isLoading ? Container() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                    onPressed: () async {
                      _formKey.currentState?.saveAndValidate();
                      print(_formKey.currentState?.value);
                      var request = new Map.from(_formKey.currentState!.value);
                      request['slika'] = _base64Image;

                      print(request['slika']);

                      try {
                        if (widget.vozilo == null) {
                          await _vozilaProvider.insert(request);
                        } else {
                          await _vozilaProvider.update(
                              widget.vozilo!.voziloId!, request);
                        }
                      } on Exception catch (e) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: Text("Error"),
                                  content: Text(e.toString()),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("OK"))
                                  ],
                                ));
                      }
                    },
                    child: Text("Sačuvaj")),
              )
            ],
          )
        ],
      ),
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
            ],
          ),
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
                    hintText: 'Odaberi marku vozila',
                  ),
                  items: tipVozilaResult?.result
                          .map((item) => DropdownMenuItem(
                                alignment: AlignmentDirectional.center,
                                value: item.tipVozilaId.toString(),
                                child: Text(item.marka ?? ""),
                              ))
                          .toList() ??
                      [],
                ),
              )
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: FormBuilderField(
                name: 'imageId',
                builder: ((field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                        label: Text('Odaberite sliku'),
                        errorText: field.errorText),
                    child: ListTile(
                      leading: Icon(Icons.photo),
                      title: Text("Select image"),
                      trailing: Icon(Icons.file_upload),
                      onTap: getImage,
                    ),
                  );
                }),
              ))
            ],
          )
        ],
      ),
    );
  }

  File? _image;
  String? _base64Image;

  Future getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      _base64Image = base64Encode(_image!.readAsBytesSync());
    }
  }
}
