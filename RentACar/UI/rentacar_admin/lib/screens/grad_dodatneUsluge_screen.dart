import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/providers/dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';

class GradDodatneUslugeScreen extends StatefulWidget {
  final Grad? grad;
  final DodatnaUsluga? dodatnaUsluga;
  final Rezervacija? rezervacija;

  const GradDodatneUslugeScreen(
      {Key? key, this.grad, this.dodatnaUsluga, this.rezervacija})
      : super(key: key);

  @override
  _GradDodatneUslugeScreenState createState() =>
      _GradDodatneUslugeScreenState();
}

class _GradDodatneUslugeScreenState extends State<GradDodatneUslugeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late GradProvider _gradProvider;
  late DodatnaUslugaProvider _dodatnaUslugaProvider;
  SearchResult<Rezervacija>? rezervacijaResult;
  late RezervacijaProvider _rezervacijaProvider;
  late TextEditingController _nazivController;

  SearchResult<Grad>? gradResult;
  SearchResult<DodatnaUsluga>? dodatnaUslugaResult;
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _gradProvider = context.read<GradProvider>();
    _dodatnaUslugaProvider = context.read<DodatnaUslugaProvider>();
    _rezervacijaProvider = RezervacijaProvider();

    initForm();
  }

  Future<void> initForm() async {
    gradResult = await _gradProvider.get();
    dodatnaUslugaResult = await _dodatnaUslugaProvider.get();
    rezervacijaResult = await _rezervacijaProvider.get();

    setState(() {
      isLoading = false;
    });
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

  bool gradExists(String naziv) {
    if (gradResult == null) return false;
    return gradResult!.result
        .any((grad) => grad.naziv?.toLowerCase() == naziv.toLowerCase());
  }

  void _showGradDialog() {
    final gradFormKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dodaj grad'),
          content: FormBuilder(
            key: gradFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: FormBuilderTextField(
              name: 'naziv',
              decoration: InputDecoration(labelText: 'Naziv'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Polje je obavezno';
                }
                if (gradExists(value)) {
                  return 'Grad već postoji!';
                }
                return null;
              },
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
                if (gradFormKey.currentState?.saveAndValidate() ?? false) {
                  var request = Map<String, dynamic>.from(
                      gradFormKey.currentState!.value);

                  try {
                    await _gradProvider.insert(request);
                    await initForm();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Novi grad dodan u listu!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    print('Error adding grad: $e');
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
                  decoration: InputDecoration(labelText: 'Cijena'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje je obavezno';
                    }
                    final double? parsedValue = double.tryParse(value);
                    if (parsedValue == null) {
                      return 'Samo brojčane vrijednosti!';
                    }
                    if (parsedValue <= 0) {
                      return 'Cijena mora biti veća od 0';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Gradovi i dodatne usluge'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.only(top: 20, left: 8, right: 8, bottom: 10),
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
                                'Upravljajte gradovima i dodatnim uslugama za rezervacije vozila.\n',
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
                                'Gradovi i dodatne usluge koji su uključeni u neku od postojećih rezervacija ne mogu biti obrisani!',
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
                          onPressed: _showGradDialog,
                          child: Text('Dodaj grad'),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _showDodatnaUslugaDialog,
                          child: Text('Dodaj dodatnu uslugu'),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
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
                                label: Text(
                                  'Gradovi',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                            rows: gradResult?.result.map((grad) {
                                  return DataRow(cells: [
                                    DataCell(
                                      Container(
                                        width: 200,
                                        child: Text(grad.naziv ?? ''),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: Tooltip(
                                          message: 'Uredi grad',
                                          child: Icon(Icons.edit,
                                              color: Colors.blue),
                                        ),
                                        onPressed: () {
                                          _showEditGradDialog(grad);
                                        },
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: Tooltip(
                                          message: 'Obriši grad',
                                          child: Icon(Icons.delete,
                                              color: Colors.red),
                                        ),
                                        onPressed: () {
                                          _deleteGrad(grad.gradId);
                                        },
                                      ),
                                    ),
                                  ]);
                                }).toList() ??
                                [],
                          ),
                        ),
                      ),
                      Expanded(
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
                                label: Text(
                                  'Dodatne usluge',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                numeric: false,
                              ),
                              DataColumn(
                                label: Text(
                                  'Cijena',
                                  style: TextStyle(fontWeight: FontWeight.bold),
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
                                      Container(
                                        child: Text(usluga.naziv ?? ''),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        width: 100,
                                        child: Text(
                                            usluga.cijena?.toString() ?? ''),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: Tooltip(
                                          message: 'Uredi dodatnu uslugu',
                                          child: Icon(Icons.edit,
                                              color: Colors.blue),
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
                                          child: Icon(Icons.delete,
                                              color: Colors.red),
                                        ),
                                        onPressed: () {
                                          _deleteUsluga(usluga.dodatnaUslugaId);
                                        },
                                      ),
                                    ),
                                  ]);
                                }).toList() ??
                                [],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  void _deleteGrad(int? gradId) async {
    try {
      if (gradId != null) {
        bool koristiSe =
            await _rezervacijaProvider.provjeriKoristenjeGrad(gradId);
        if (koristiSe) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Grad se koristi u nekoj rezervaciji!'),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        await _gradProvider.delete(gradId);
        await initForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Grad uspješno obrisan!'),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Greška prilikom brisanja grada: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Greška prilikom brisanja grada!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  void _showEditGradDialog(Grad grad) {
    _nazivController = TextEditingController(text: grad.naziv);

    final gradFormKey = GlobalKey<FormBuilderState>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Uredi grad'),
          content: FormBuilder(
            key: gradFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: FormBuilderTextField(
              name: 'naziv',
              controller: _nazivController,
              decoration: InputDecoration(
                labelText: 'Naziv',
                hintText: 'Prethodni naziv: ${grad.naziv}',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Polje je obavezno';
                }
                return null;
              },
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
                if (gradFormKey.currentState?.saveAndValidate() ?? false) {
                  var request = Map<String, dynamic>.from(
                      gradFormKey.currentState!.value);

                  try {
                    await _gradProvider.update(grad.gradId ?? 0, request);
                    await initForm();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Grad uspješno ažuriran!'),
                        duration: Duration(seconds: 2),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    print('Greška prilikom ažuriranja grada: $e');
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Polje je obavezno';
                    }
                    final double? parsedValue = double.tryParse(value);
                    if (parsedValue == null) {
                      return 'Samo brojčane vrijednosti!';
                    }
                    if (parsedValue < 1) {
                      return 'Cijena mora biti broj veći ili jednak 1';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
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
