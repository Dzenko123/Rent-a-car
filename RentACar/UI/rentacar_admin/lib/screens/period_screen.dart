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
    super.initState();
    _initialValue = {'trajanje': widget.period?.trajanje};
    _periodProvider = PeriodProvider();

    initForm();
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

    var lowerCaseValue = value.toLowerCase();
    if (periodList.any((period) => period.trajanje!.toLowerCase() == lowerCaseValue)) {
      return 'Period već postoji!';
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
        title: const Text('Unos trajanja novog perioda'),
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
                    const Text(
                      'Dodajte neki novi period za rezervaciju vozila koji ne postoji na prethodnoj tabeli. Nakon toga imate mogućnost da postavljate željene cijene za novi period. Molimo da unesete neku nepostojeću i valjanu vrijednost za trajanje novog perioda.',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16.0),
                    FormBuilderTextField(
                      name: 'trajanje',
                      decoration: const InputDecoration(labelText: 'Trajanje perioda'),
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
      try {
        if (widget.period == null) {
          await _periodProvider.insert(request);
        } else {
          await _periodProvider.update(widget.period!.periodId!, request);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Podaci su uspješno sačuvani!'), backgroundColor: Colors.green,
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
