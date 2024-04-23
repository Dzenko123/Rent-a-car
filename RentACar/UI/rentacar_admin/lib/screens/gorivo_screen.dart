import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/providers/gorivo_provider.dart';

class GorivoScreen extends StatefulWidget {
  final Gorivo? gorivo;
  const GorivoScreen({super.key, this.gorivo});

  @override
  _GorivoScreenState createState() => _GorivoScreenState();
}

class _GorivoScreenState extends State<GorivoScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late GorivoProvider _gorivoProvider;
  SearchResult<Gorivo>? gorivoResult;
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _gorivoProvider = context.read<GorivoProvider>();
    _initialValue = {'tip': widget.gorivo?.tip};
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> initForm() async {
    gorivoResult = await _gorivoProvider.get();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unos tipa goriva'),
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
        if (widget.gorivo == null) {
          await _gorivoProvider.insert(request);
        } else {
          await _gorivoProvider.update(widget.gorivo!.gorivoId!, request);
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
