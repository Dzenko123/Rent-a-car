import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/to_do_4924.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/to_do_4924_provider.dart';
import 'package:rentacar_admin/screens/to_do_4924_screen.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';
import '../models/korisnici.dart';

class ToDo4924NoviScreen extends StatefulWidget {
  ToDo4924Model? ToDo4924;
  ToDo4924NoviScreen({Key? key, this.ToDo4924}) : super(key: key);

  @override
  State<ToDo4924NoviScreen> createState() => _ToDo4924NoviScreenState();
}

class _ToDo4924NoviScreenState extends State<ToDo4924NoviScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  late ToDo4924ModelProvider _toDo4924Provider;
  late KorisniciProvider _accountProvider;
  SearchResult<Korisnici>? userResult;
  bool isLoading = true;
  bool isValid = false;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'korisnikId': widget.ToDo4924?.korisnikId,
      'status': widget.ToDo4924?.status ?? 'U toku',
    };

    _toDo4924Provider = context.read<ToDo4924ModelProvider>();
    _accountProvider = context.read<KorisniciProvider>();
    initForm();
  }

  Future initForm() async {
    userResult = await _accountProvider.get();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To do 4924'),
      ),
      body: Column(
        children: [
          isLoading ? CircularProgressIndicator() : _buildForm(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        try {
                          _formKey.currentState?.saveAndValidate();
                          var formValue = _formKey.currentState?.value;
                          var request = {
                            'nazivAktivnosti': formValue!['nazivAktivnosti'],
                            'opisAktivnosti': formValue['opisAktivnosti'],
                            'datumIzvrsenja': formValue['datumIzvrsenja']?.toIso8601String(),
                            'status': formValue['status'],
                            'korisnikId': formValue['korisnikId'],
                          };
                          if (widget.ToDo4924 == null) {
                            await _toDo4924Provider.insert(request);
                          } else {
                            await _toDo4924Provider.update(widget.ToDo4924!.toDo4924Id!, request);
                          }

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ToDo4924ListScreen()));
                        } on Exception catch (e) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: Text("Error"),
                                content: Text(e.toString()),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: Text("OK"))
                                ],
                              ));
                        }
                      }
                    },
                    child: Text("Save")),
              ),
              if (widget.ToDo4924 != null) ...[
              ]
            ],
          )
        ],
      ),
    );
  }

  Padding _buildForm() {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        autovalidateMode: AutovalidateMode.disabled,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderDropdown<String>(
                          name: 'korisnikId',
                          decoration: InputDecoration(
                            labelText: 'User',
                            suffix: IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _formKey.currentState!.fields['korisnikId']?.reset();
                              },
                            ),
                            hintText: 'Select user',
                          ),
                          items: userResult?.result
                              .map(
                                (item) => DropdownMenuItem(
                              alignment: AlignmentDirectional.center,
                              value: item.korisnikId.toString(),
                              child: Text(item.ime ?? ""),
                            ),
                          )
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
                        child: FormBuilderTextField(
                          name: 'nazivAktivnosti',
                          decoration: InputDecoration(
                            labelText: 'Naziv Aktivnosti',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderTextField(
                          name: 'opisAktivnosti',
                          decoration: InputDecoration(
                            labelText: 'Opis Aktivnosti',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderDateTimePicker(
                          name: 'datumIzvrsenja',
                          decoration: InputDecoration(
                            labelText: 'Datum Izvršenja',
                          ),
                          initialEntryMode: DatePickerEntryMode.calendar,
                          inputType: InputType.date,
                          format: DateFormat('dd-MM-yyyy'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: FormBuilderDropdown<String>(
                          name: 'status',
                          decoration: InputDecoration(
                            labelText: 'Status',
                          ),
                          items: ['U toku', 'Završeno', 'Otkazano']
                              .map(
                                (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ),
                          )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
