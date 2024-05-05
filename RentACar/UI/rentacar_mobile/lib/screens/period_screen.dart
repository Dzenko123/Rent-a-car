import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rentacar_admin/models/period.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/providers/period_provider.dart';

class PeriodScreen extends StatefulWidget {
  final Period? period;
  const PeriodScreen({super.key, this.period});

  @override
  _PeriodScreenState createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late PeriodProvider _periodProvider;
  SearchResult<Period>? periodResult;
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  bool _autoValidate = false;
  List<Period> periodList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {'trajanje': widget.period?.trajanje};
    _periodProvider = PeriodProvider();

    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  String? _validatePeriod(String? value) {
    if (value == null || !RegExp(r'^\d+-\d+ dana$').hasMatch(value)) {
      return 'Format treba biti "n-n dana"';
    }

    var parts = value.split('-');
    var firstDay = int.tryParse(parts[0]);
    var secondDay = int.tryParse(parts[1].split(' ')[0]);

    if (firstDay == null || secondDay == null || firstDay >= secondDay) {
      return 'Prvi dan treba biti manji od drugog';
    }

    return null;
  }

  Future<void> initForm() async {
    periodResult = await _periodProvider.get();
    setState(() {
      isLoading = false;
      periodList = periodResult!.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unos trajanje perioda'),
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
                      name: 'trajanje',
                      decoration:
                          const InputDecoration(labelText: 'Trajanje perioda'),
                      onChanged: (value) {
                        setState(() {
                          _autoValidate = true;
                        });
                      },
                      autovalidateMode: _autoValidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: _validatePeriod,
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
    var novoTrajanje = (request['trajanje'] as String?)?.toLowerCase();

    if (periodList.any((period) => period.trajanje!.toLowerCase() == novoTrajanje)) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Greška"),
          content: Text("Period '$novoTrajanje' već postoji!"),
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
      if (widget.period == null) {
        await _periodProvider.insert(request);
      } else {
        await _periodProvider.update(widget.period!.periodId!, request);
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
