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
  bool _autoValidate = false;
  List<Gorivo> gorivaList = [];
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
if(mounted){
    setState(() {
      isLoading = false;
      gorivaList = gorivoResult!.result;
    });
  }
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
    var novoTipGoriva = (request['tip'] as String?)?.toLowerCase();

    if (gorivaList.any((gorivo) => gorivo.tip?.toLowerCase() == novoTipGoriva)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Greška"),
          content: Text("Tip goriva '$novoTipGoriva' već postoji!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    try {
      Gorivo? savedGorivo;
      if (widget.gorivo == null) {
        savedGorivo = await _gorivoProvider.insert(request);
      } else {
        savedGorivo = await _gorivoProvider.update(widget.gorivo!.gorivoId!, request);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.green,
          content: Text('Podaci su uspješno sačuvani!'),
        ),
      );

      if (mounted) {
        Navigator.of(context).pop(savedGorivo);
      }
    } catch (e) {
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
  }
}

}
