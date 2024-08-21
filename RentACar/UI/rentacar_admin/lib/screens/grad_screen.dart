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

class GradScreen extends StatefulWidget {
  final Grad? grad;
  final Rezervacija? rezervacija;

  const GradScreen({Key? key, this.grad, this.rezervacija}) : super(key: key);

  @override
  _GradScreenState createState() => _GradScreenState();
}

class _GradScreenState extends State<GradScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late GradProvider _gradProvider;
  SearchResult<Rezervacija>? rezervacijaResult;
  late RezervacijaProvider _rezervacijaProvider;
  late TextEditingController _nazivController;

  SearchResult<Grad>? gradResult;
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _gradProvider = context.read<GradProvider>();
    _rezervacijaProvider = RezervacijaProvider();
    _nazivController = TextEditingController();
    initForm();
  }

  Future<void> initForm() async {
    gradResult = await _gradProvider.get();
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

 @override
Widget build(BuildContext context) {
  return MasterScreenWidget(
    title_widget: const Text("Gradovi"),
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
                              'Upravljajte gradovima.\n',
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
                              'Gradovi koji su uključeni u neku od postojećih rezervacija ne mogu biti obrisani!',
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
                                'Gradovi',
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
                        rows: gradResult?.result.map((grad) {
                          return DataRow(cells: [
                            DataCell(
                              Text(grad.naziv ?? ''),
                            ),
                            DataCell(
                              IconButton(
                                icon: Tooltip(
                                  message: 'Uredi grad',
                                  child: Icon(Icons.edit, color: Colors.blue),
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
                                  child: Icon(Icons.delete, color: Colors.red),
                                ),
                                onPressed: () {
                                  _deleteGrad(grad.gradId);
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

  void _showEditGradDialog(Grad grad) {
    _nazivController.text = grad.naziv!;

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
}
