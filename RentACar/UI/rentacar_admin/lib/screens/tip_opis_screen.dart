import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';

class TipOpisScreen extends StatefulWidget {
  final TipVozila? tipVozila;

  const TipOpisScreen({super.key, this.tipVozila});

  @override
  _TipOpisScreenState createState() => _TipOpisScreenState();
}

class _TipOpisScreenState extends State<TipOpisScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late TipVozilaProvider _tipVozilaProvider;
  SearchResult<TipVozila>? tipVozilaResult;
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> initForm() async {
    // setState(() {
    //   isLoading = true;
    // });

    tipVozilaResult = await _tipVozilaProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unos Tipa i Opisa'),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormBuilderTextField(
                      name: 'tip',
                      decoration: const InputDecoration(labelText: 'Tip'),
                    ),
                    const SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'opis',
                      decoration: const InputDecoration(labelText: 'Opis'),
                      maxLines: 3,
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
      var request = Map.from(_formKey.currentState!.value);

      try {
        if (widget.tipVozila == null) {
          await _tipVozilaProvider.insert(request);
        } else {
          await _tipVozilaProvider.update(
              widget.tipVozila!.tipVozilaId!, request);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Podaci su uspješno sačuvani!'),
          ),
        );

        Navigator.of(context).pop(true);
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
    }
  }
}
