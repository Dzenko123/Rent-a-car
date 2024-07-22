import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';

class TipOpisScreen extends StatefulWidget {
  final TipVozila? tipVozila;

  const TipOpisScreen({Key? key, this.tipVozila}) : super(key: key);

  @override
  _TipOpisScreenState createState() => _TipOpisScreenState();
}

class _TipOpisScreenState extends State<TipOpisScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late TipVozilaProvider _tipVozilaProvider;
  SearchResult<TipVozila>? tipVozilaResult;
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _tipVozilaProvider = context.read<TipVozilaProvider>();
    _initialValue = {
      'tip': widget.tipVozila?.tip,
      'opis': widget.tipVozila?.opis,
    };
    initForm();
  }

  Future<void> initForm() async {
    tipVozilaResult = await _tipVozilaProvider.get();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unos tipa i opisa za vozilo'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: FormBuilder(
                key: _formKey,
                initialValue: _initialValue,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormBuilderTextField(
                      name: 'tip',
                      decoration: const InputDecoration(labelText: 'Tip'),
                      onChanged: (value) {
                        setState(() {
                          _autoValidate = true;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Polje je obavezno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'opis',
                      decoration: const InputDecoration(labelText: 'Opis'),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          _autoValidate = true;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Polje je obavezno';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _saveForm();
                      },
                      child: const Text('Spremi'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

 void _saveForm() async {
  if (_formKey.currentState!.saveAndValidate()) {
    var request = Map<String, dynamic>.from(_formKey.currentState!.value);
    TipVozila? savedTipVozila;

    try {
      if (widget.tipVozila == null) {
        savedTipVozila = await _tipVozilaProvider.insert(request);
      } else {
        savedTipVozila = await _tipVozilaProvider.update(widget.tipVozila!.tipVozilaId!, request);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green,
          content: Text('Podaci su uspješno sačuvani!'),
        ),
      );

      if (mounted) {Navigator.of(context).pop(savedTipVozila);}
    }on Exception catch (e) {
        if (mounted) {
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
      }
    }
  }
}
