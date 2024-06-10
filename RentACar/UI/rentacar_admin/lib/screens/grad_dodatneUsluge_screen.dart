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

  const GradDodatneUslugeScreen({Key? key, this.grad, this.dodatnaUsluga, this.rezervacija}) : super(key: key);

  @override
  _GradDodatneUslugeScreenState createState() => _GradDodatneUslugeScreenState();
}

class _GradDodatneUslugeScreenState extends State<GradDodatneUslugeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late GradProvider _gradProvider;
  late DodatnaUslugaProvider _dodatnaUslugaProvider;
  SearchResult<Rezervacija>? rezervacijaResult;
  late RezervacijaProvider _rezervacijaProvider;

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

 void _showGradDialog() {
  final gradFormKey = GlobalKey<FormBuilderState>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Dodaj Grad'),
        content: FormBuilder(
          key: gradFormKey,
          child: FormBuilderTextField(
            name: 'naziv',
            decoration: InputDecoration(labelText: 'Naziv'),
validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Polje je obavezno';
                }
                return null;
              },          ),
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
                var request = Map<String, dynamic>.from(gradFormKey.currentState!.value);
                
                try {
                  await _gradProvider.insert(request);
                  await initForm();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dodano!'),
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
        title: Text('Dodaj Dodatnu Uslugu'),
        content: FormBuilder(
          key: dodatnaUslugaFormKey,
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
                    return null;
                  },              ),
              FormBuilderTextField(
                name: 'cijena',
                decoration: InputDecoration(labelText: 'Cijena'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Polje je obavezno';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Samo brojčane vrijednosti!';
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
              if (dodatnaUslugaFormKey.currentState?.saveAndValidate() ?? false) {
                var request = Map<String, dynamic>.from(dodatnaUslugaFormKey.currentState!.value);
                
                try {
                  await _dodatnaUslugaProvider.insert(request);
                  await initForm();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dodano!'),
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
        title: Text('Gradovi i Dodatne Usluge'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(top:20, left: 8, right: 8, bottom: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: _showGradDialog,
                        child: Text('Dodaj Grad'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _showDodatnaUslugaDialog,
                        child: Text('Dodaj Dodatnu Uslugu'),
                      ),
                    ],
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
                              DataColumn(label: Text('Gradovi', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Akcije', style: TextStyle(fontWeight: FontWeight.bold))),

                            ],
                            rows: gradResult?.result.map((grad) {
                              return DataRow(cells: [
                                DataCell(Text(grad.naziv ?? '')),
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
                              DataColumn(label: Text('Dodatne usluge', style: TextStyle(fontWeight: FontWeight.bold))),
                              DataColumn(label: Text('Cijena', style: TextStyle(fontWeight: FontWeight.bold))),
                                                            DataColumn(label: Text('Akcije', style: TextStyle(fontWeight: FontWeight.bold))),

                            ],
                            rows: dodatnaUslugaResult?.result.map((usluga) {
                              return DataRow(cells: [
                                DataCell(Text(usluga.naziv ?? '')),
                                DataCell(Text(usluga.cijena?.toString() ?? '')),
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
      bool koristiSe = await _rezervacijaProvider.provjeriKoristenjeGrad(gradId);
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
      bool koristiSe = await _rezervacijaProvider.provjeriKoristenjeUsluga(uslugaId);
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

}
