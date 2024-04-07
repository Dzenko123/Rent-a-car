import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rentacar_admin/models/period.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/providers/period_provider.dart';

class PeriodScreen extends StatefulWidget {
  final Period? period;
  PeriodScreen({Key? key, this.period}) : super(key: key);

  @override
  _PeriodScreenState createState() => _PeriodScreenState();
}

class _PeriodScreenState extends State<PeriodScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late PeriodProvider _periodProvider;
  SearchResult<Period>? periodResult;
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};

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

  Future<void> initForm() async {
    periodResult = await _periodProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Unos trajanje perioda'),
      ),
      body: isLoading
          ? Center(
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
                      decoration: InputDecoration(labelText: 'Trajanje period'),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        _saveForm();
                        
                      },
                      child: Text('Spremi'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _saveForm() async {
    if (_formKey.currentState!.saveAndValidate()) {
      var formData = _formKey.currentState!.value;
      var request = new Map.from(_formKey.currentState!.value);

      try {
        if (widget.period == null) {
          await _periodProvider.insert(request);
        } else {
          await _periodProvider.update(widget.period!.periodId!, request);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Podaci su uspješno sačuvani!'),
          ),
        );

        Navigator.of(context).pop(true);
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
    }
  }
}
