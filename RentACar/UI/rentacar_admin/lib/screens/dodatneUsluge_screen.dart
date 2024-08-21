import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/providers/dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class DodatneUslugeScreen extends StatefulWidget {
  final DodatnaUsluga? dodatnaUsluga;
  final Rezervacija? rezervacija;

  const DodatneUslugeScreen({Key? key, this.dodatnaUsluga, this.rezervacija})
      : super(key: key);

  @override
  _DodatneUslugeScreenState createState() => _DodatneUslugeScreenState();
}

class _DodatneUslugeScreenState extends State<DodatneUslugeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late DodatnaUslugaProvider _dodatnaUslugaProvider;
  SearchResult<Rezervacija>? rezervacijaResult;
  late RezervacijaProvider _rezervacijaProvider;
  late TextEditingController _nazivController;

  SearchResult<DodatnaUsluga>? dodatnaUslugaResult;
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _dodatnaUslugaProvider = context.read<DodatnaUslugaProvider>();
    _rezervacijaProvider = RezervacijaProvider();
    _nazivController = TextEditingController();
    initForm();
  }

  Future<void> initForm() async {
    dodatnaUslugaResult = await _dodatnaUslugaProvider.get();
    rezervacijaResult = await _rezervacijaProvider.get();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nazivController.dispose();
    super.dispose();
  }

  bool dodatnaUslugaExists(String naziv) {
    if (dodatnaUslugaResult == null) return false;
    return dodatnaUslugaResult!.result
        .any((usluga) => usluga.naziv?.toLowerCase() == naziv.toLowerCase());
  }

  void _showDodatnaUslugaDialog() {
    final dodatnaUslugaFormKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dodaj dodatnu uslugu'),
          content: FormBuilder(
            key: dodatnaUslugaFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'naziv',
                  decoration: InputDecoration(labelText: 'Naziv'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje je obavezno';
                    }
                    if (dodatnaUslugaExists(value)) {
                      return 'Dodatna usluga već postoji!';
                    }
                    return null;
                  },
                ),
                FormBuilderTextField(
                  name: 'cijena',
                  decoration: const InputDecoration(
                    labelText: 'Cijena',
                    hintText: 'Format cijene: npr. 67.55',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    _initialValue['cijena'] = value;
                    _formKey.currentState?.validate();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}$')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Molimo unesite cijenu.';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Dodaj'),
              onPressed: () async {
                if (dodatnaUslugaFormKey.currentState?.saveAndValidate() ??
                    false) {
                  var request = Map<String, dynamic>.from(
                      dodatnaUslugaFormKey.currentState!.value);

                  try {
                    await _dodatnaUslugaProvider.insert(request);
                    await initForm();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Nova dodatna usluga dodana u listu!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    print('Error adding dodatna usluga: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Greška!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

@override
Widget build(BuildContext context) {
  return MasterScreenWidget(
    title_widget: const Text("Dodatne usluge"),
    child: isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.only(
                top: 20, left: 35, right: 8, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Upravljajte dodatnim uslugama za rezervacije vozila.\n',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'NAPOMENA - ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Dodatne usluge koje su uključene u neku od postojećih rezervacija ne mogu biti obrisane!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ElevatedButton(
                        onPressed: _showDodatnaUslugaDialog,
                        child: Text('Dodaj dodatnu uslugu'),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.all(8.0),
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Container(width: 200,
                              child: Text(
                                'Dodatne usluge',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Container(width: 100,
                              child: Text(
                                'Cijena',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Text(
                              'Uređivanje',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            numeric: false,
                          ),
                          DataColumn(
                            label: Text(
                              'Brisanje',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            numeric: false,
                          ),
                        ],
                        rows: dodatnaUslugaResult?.result.map((usluga) {
                          return DataRow(cells: [
                            DataCell(
                              Text(usluga.naziv ?? ''),
                            ),
                            DataCell(
                              Text(usluga.cijena?.toString() ?? ''),
                            ),
                            DataCell(
                              IconButton(
                                icon: Tooltip(
                                  message: 'Uredi dodatnu uslugu',
                                  child: Icon(Icons.edit, color: Colors.blue),
                                ),
                                onPressed: () {
                                  _showEditDodatnaUslugaDialog(usluga);
                                },
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: Tooltip(
                                  message: 'Obriši dodatnu uslugu',
                                  child: Icon(Icons.delete, color: Colors.red),
                                ),
                                onPressed: () {
                                  _deleteUsluga(usluga.dodatnaUslugaId);
                                },
                              ),
                            ),
                          ]);
                        }).toList() ?? [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
  );
}

  void _deleteUsluga(int? uslugaId) async {
    try {
      if (uslugaId != null) {
        bool koristiSe =
            await _rezervacijaProvider.provjeriKoristenjeUsluga(uslugaId);
        if (koristiSe) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Dodatna usluga se koristi u nekoj rezervaciji!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        await _dodatnaUslugaProvider.delete(uslugaId);
        await initForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Dodatna usluga uspješno obrisana!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Greška prilikom brisanja dodatne usluge: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom brisanja dodatne usluge!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showEditDodatnaUslugaDialog(DodatnaUsluga usluga) {
    _nazivController = TextEditingController(text: usluga.naziv);
    final _cijenaController =
        TextEditingController(text: usluga.cijena?.toString() ?? '');

    final dodatnaUslugaFormKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uredi dodatnu uslugu'),
          content: FormBuilder(
            key: dodatnaUslugaFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'naziv',
                  controller: _nazivController,
                  decoration: InputDecoration(
                    labelText: 'Naziv',
                    hintText: 'Prethodni naziv: ${usluga.naziv}',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje je obavezno';
                    }
                    return null;
                  },
                ),
                FormBuilderTextField(
                  name: 'cijena',
                  controller: _cijenaController,
                  decoration: InputDecoration(
                    labelText: 'Cijena',
                    hintText:
                        'Prethodna cijena: ${usluga.cijena?.toString() ?? ''}',
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    _initialValue['cijena'] = value;
                    _formKey.currentState?.validate();
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}$')),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje je obavezno';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Odustani'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Spremi'),
              onPressed: () async {
                if (dodatnaUslugaFormKey.currentState?.saveAndValidate() ??
                    false) {
                  var request = Map<String, dynamic>.from(
                      dodatnaUslugaFormKey.currentState!.value);

                  try {
                    await _dodatnaUslugaProvider.update(
                        usluga.dodatnaUslugaId ?? 0, request);
                    await initForm();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Dodatna usluga uspješno ažurirana!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    print('Greška prilikom ažuriranja dodatne usluge: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Greška!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}
