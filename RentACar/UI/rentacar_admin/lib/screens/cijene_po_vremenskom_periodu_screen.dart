import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rentacar_admin/models/cijene_po_vremenskom_periodu.dart';
import 'package:rentacar_admin/models/period.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/cijene_po_vremenskom_periodu_provider.dart';
import 'package:rentacar_admin/providers/period_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/period_screen.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class CijenePoVremenskomPerioduScreen extends StatefulWidget {
  CijenePoVremenskomPeriodu? cijenePoVremenskomPeriodu;
  CijenePoVremenskomPerioduScreen({super.key});

  @override
  State<CijenePoVremenskomPerioduScreen> createState() =>
      _CijenePoVremenskomPerioduScreenState();
}

class _CijenePoVremenskomPerioduScreenState
    extends State<CijenePoVremenskomPerioduScreen> {
  SearchResult<CijenePoVremenskomPeriodu>? cijenePoVremenskomPerioduResult;
  SearchResult<Period>? periodResult;
  SearchResult<Vozilo>? vozilaResult;
  late CijenePoVremenskomPerioduProvider _cijenePoVremenskomPerioduProvider;
  late PeriodProvider _periodProvider;
  late VozilaProvider _vozilaProvider;

  TextEditingController _ftsController = new TextEditingController();
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'voziloId': widget.cijenePoVremenskomPeriodu?.voziloId.toString(),
      'periodId': widget.cijenePoVremenskomPeriodu?.periodId.toString(),
      'cijena': widget.cijenePoVremenskomPeriodu?.cijena.toString()
    };
    _cijenePoVremenskomPerioduProvider = CijenePoVremenskomPerioduProvider();
    _periodProvider = PeriodProvider();
    _vozilaProvider = VozilaProvider();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> initForm() async {
    cijenePoVremenskomPerioduResult =
        await _cijenePoVremenskomPerioduProvider.get();
    periodResult = await _periodProvider.get();
    vozilaResult = await _vozilaProvider.get();

    print("Cijene po vremenskom periodu: $cijenePoVremenskomPerioduResult");
    print("Periodi: $periodResult");
    print("Vozila: $vozilaResult");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Cijene vozila"),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearch(),
                SizedBox(height: 16),
                Container(
                  // decoration: BoxDecoration(
                  //   color: Colors.grey[200],
                  //   borderRadius: BorderRadius.circular(10),
                  // ),
                  child: _buildDataListView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    Set<int> existingVehicles = Set<int>.from(cijenePoVremenskomPerioduResult
            ?.result
            .map((cijena) => cijena.voziloId) ??
        []);

    List<Vozilo> availableVehicles = vozilaResult?.result
            .where((vozilo) => !existingVehicles.contains(vozilo.voziloId))
            .toList() ??
        [];

    _initialValue['periodId'] = '1';
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Flexible(
          //   child: TextField(
          //     decoration: const InputDecoration(
          //       labelText: "Pretraga:",
          //       labelStyle: TextStyle(color: Colors.black),
          //     ),
          //     controller: _ftsController,
          //     style: TextStyle(color: Colors.black),
          //   ),
          // ),
          // SizedBox(width: 8),
          // Flexible(
          //   child: ElevatedButton(
          //     onPressed: () async {
          //       print("Pretraga uspješna");
          //       await initForm();
          //       setState(() {});
          //     },
          //     child: const Text("Pretraga"),
          //     style: ElevatedButton.styleFrom(
          //       padding: EdgeInsets.symmetric(horizontal: 10.0),
          //     ),
          //   ),
          // ),
          SizedBox(width: 10),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => PeriodScreen(period: null)),
                );
                if (result == true) {
                  setState(() {
                    isLoading = true;
                  });
                  initForm();
                }
              },
              child: const Text("Otvori PeriodScreen"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
            ),
          ),
          SizedBox(width: 10),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                var enteredValues = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Unesi novo vozilo'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _initialValue['voziloId'] = availableVehicles
                                    .isNotEmpty
                                ? availableVehicles.first.voziloId.toString()
                                : null,
                            items: availableVehicles.map((vozilo) {
                              return DropdownMenuItem<String>(
                                value: vozilo.voziloId.toString(),
                                child: Text(
                                    'Marka:${vozilo.marka}; model: ${vozilo.model}'),
                              );
                            }).toList(),
                            onChanged: (String? selectedValue) {
                              _initialValue['voziloId'] = selectedValue;
                            },
                            decoration: InputDecoration(labelText: 'Vozilo'),
                          ),
                          TextFormField(
                            initialValue: '1',
                            decoration: InputDecoration(labelText: 'Period ID'),
                            onChanged: (value) {
                              _initialValue['periodId'] = value;
                            },
                          ),
                          TextFormField(
                            initialValue: '0',
                            decoration: InputDecoration(labelText: 'Cijena'),
                            onChanged: (value) {
                              _initialValue['cijena'] = value;
                            },
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_initialValue['voziloId'] != null &&
                                _initialValue['periodId'] != null &&
                                _initialValue['cijena'] != null) {
                              Navigator.of(context).pop(_initialValue);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Molimo unesite sve vrijednosti.'),
                                ),
                              );
                            }
                          },
                          child: Text('Save'),
                        ),
                      ],
                    );
                  },
                );

                if (enteredValues != null) {
                  int voziloId =
                      int.tryParse(enteredValues['voziloId'] ?? '') ?? 0;
                  int periodId =
                      int.tryParse(enteredValues['periodId'] ?? '') ?? 0;
                  double cijena =
                      double.tryParse(enteredValues['cijena'] ?? '') ?? 0.0;

                  var newCijena = CijenePoVremenskomPeriodu(
                    voziloId: voziloId,
                    periodId: periodId,
                    cijena: cijena,
                  );
                  print("New CijenePoVremenskomPeriodu object: $newCijena");

                  try {
                    print('Novi CijenePoVremenskomPeriodu:');
                    print(newCijena.toJson());
                    var result = await _cijenePoVremenskomPerioduProvider
                        .insert(newCijena);

                    print("Novi CijenePoVremenskomPeriodu spremljen: $result");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Podaci uspješno spremljeni!')),
                    );
                    await initForm();
                    setState(() {});
                  } catch (e) {
                    print("Greška prilikom spremanja: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Došlo je do pogreške pri spremanju podataka.')),
                    );
                  }
                }
              },
              child: Text('Unesi novo vozilo u tabelu'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataListView() {
    Map<int, List<CijenePoVremenskomPeriodu>> groupedResults = {};
    cijenePoVremenskomPerioduResult?.result.forEach((cijena) {
      if (!groupedResults.containsKey(cijena.voziloId)) {
        groupedResults[cijena.voziloId!] = [];
      }
      groupedResults[cijena.voziloId!]!.add(cijena);
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            dataRowHeight: 120,
            columns: [
              DataColumn(
                label: Text(
                  'Vozilo',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Model',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              DataColumn(
                label: Text(
                  'Marka',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              ...(periodResult?.result.map<DataColumn>((period) {
                    return DataColumn(
                      label: Text(
                        '${period.trajanje}',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    );
                  }).toList() ??
                  []),
            ],
            rows: groupedResults.entries.map<DataRow>((entry) {
              int voziloId = entry.key;
              List<CijenePoVremenskomPeriodu> cijene = entry.value;

              Vozilo? vozilo = vozilaResult?.result
                  .firstWhere((vozilo) => vozilo.voziloId == voziloId);

              return DataRow(
                color: MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.08);
                    }
                    return null;
                  },
                ),
                cells: [
                  DataCell(
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        width: 180,
                        height: 100,
                        child: vozilo != null && vozilo.slika != null
                            ? Image.memory(
                                base64Decode(vozilo.slika!),
                                fit: BoxFit.contain,
                              )
                            : Text(voziloId.toString()),
                      ),
                    ),
                  ),
                  DataCell(
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(vozilo?.model ?? "", style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  DataCell(
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(vozilo?.marka ?? "", style: TextStyle(color: Colors.red),),
                      
                    ),
                  ),
                  ...(periodResult?.result.map<DataCell>((period) {
                        CijenePoVremenskomPeriodu? cijenaZaPeriod =
                            cijene.firstWhere(
                          (cijena) => cijena.periodId == period.periodId,
                          orElse: () => CijenePoVremenskomPeriodu.fromJson({
                            'voziloId': voziloId,
                            'periodId': period.periodId,
                            'cijena': null,
                          }),
                        );
                        return DataCell(
                          cijenaZaPeriod.cijena != null
                              ? GestureDetector(
                                  onTap: () async {
                                    double? newPrice = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        double currentPrice =
                                            cijenaZaPeriod?.cijena ?? 0.0;
                                        return AlertDialog(
                                          title: Text('Uredi cijenu'),
                                          content: TextFormField(
                                            initialValue:
                                                currentPrice.toString(),
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              currentPrice =
                                                  double.tryParse(value) ??
                                                      currentPrice;
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(null);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(currentPrice);
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (newPrice != null) {
                                      setState(() {
                                        cijenaZaPeriod!.cijena = newPrice;
                                      });
                                      await _cijenePoVremenskomPerioduProvider
                                          .update(
                                              cijenaZaPeriod
                                                  .cijenePoVremenskomPerioduId!,
                                              cijenaZaPeriod);
                                    }
                                  },
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                        cijenaZaPeriod.cijena?.toString() ??
                                            ""),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    double? enteredPrice =
                                        await showDialog<double>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Unesi cijenu'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Vozilo ID: $voziloId'),
                                              Text(
                                                  'Period ID: ${period.periodId}'),
                                              TextField(
                                                decoration: InputDecoration(
                                                    labelText: 'Cijena'),
                                                onChanged: (value) {
                                                  _initialValue['cijena'] =
                                                      value;
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(null);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                double cijena = double.tryParse(
                                                        _initialValue[
                                                                'cijena'] ??
                                                            '') ??
                                                    0.0;

                                                var newCijena =
                                                    CijenePoVremenskomPeriodu(
                                                  voziloId: voziloId,
                                                  periodId: period.periodId,
                                                  cijena: cijena,
                                                );
                                                print(
                                                    "New CijenePoVremenskomPeriodu object: $newCijena");

                                                try {
                                                  print(
                                                      'Novi CijenePoVremenskomPeriodu:');
                                                  print(newCijena.toJson());
                                                  var result =
                                                      await _cijenePoVremenskomPerioduProvider
                                                          .insert(newCijena);

                                                  print(
                                                      "Novi CijenePoVremenskomPeriodu spremljen: $result");
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Podaci uspješno spremljeni!')),
                                                  );
                                                  Navigator.of(context).pop();
                                                  await initForm();
                                                  setState(() {});
                                                } catch (e) {
                                                  print(
                                                      "Greška prilikom spremanja: $e");
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Došlo je do pogreške pri spremanju podataka.')),
                                                  );
                                                }
                                              },
                                              child: Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (enteredPrice != null) {}
                                  },
                                  child: Text('Unesi cijenu'),
                                ),
                        );
                      }).toList() ??
                      []),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
