import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final TextEditingController _ftsController = TextEditingController();
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  int? minPeriodId;

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

    if (periodResult?.result.isNotEmpty ?? false) {
      minPeriodId = periodResult!.result
          .map((period) => period.periodId!)
          .reduce((a, b) => a < b ? a : b);
    }

    print("Cijene po vremenskom periodu: $cijenePoVremenskomPerioduResult");
    print("Periodi: $periodResult");
    print("Vozila: $vozilaResult");
    setState(() {});
  }

  Future<void> _deletePeriod(int periodId) async {
    try {
      await _periodProvider.deletePeriod(periodId);
      await initForm();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Period uspješno obrisan.')),
      );
    } catch (e) {
      print('Greška prilikom brisanja perioda: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Došlo je do pogreške prilikom brisanja perioda.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: const Text("Cijene vozila"),
      child: Container( decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF000000),
              Color.fromARGB(255, 68, 68, 68),
              Color.fromARGB(255, 148, 147, 147),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearch(),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
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

    _initialValue['periodId'] = minPeriodId.toString();
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
          const SizedBox(width: 10),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const PeriodScreen(period: null)),
                );
                if (result == true) {
                  setState(() {
                    isLoading = true;
                  });
                  initForm();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
              ),
              child: const Text("Otvori PeriodScreen"),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                var enteredValues = await showDialog<Map<String, dynamic>>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Unesi novo vozilo'),
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
                            decoration: const InputDecoration(labelText: 'Vozilo'),
                          ),
                          TextFormField(
                            initialValue: minPeriodId.toString(),
                            decoration: const InputDecoration(labelText: 'Period ID'),
                            readOnly: true,
                            onChanged: (value) {
                              _initialValue['periodId'] =
                                  minPeriodId.toString();
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Cijena',
                              hintText: 'Format cijene: npr. 67.5',
                            ),
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (value) {
                              _initialValue['cijena'] = value;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,1}$')),
                            ],
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_initialValue['voziloId'] != null &&
                                _initialValue['periodId'] != null &&
                                _initialValue['cijena'] != null) {
                              Navigator.of(context).pop(_initialValue);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Molimo unesite sve vrijednosti.'),
                                ),
                              );
                            }
                          },
                          child: const Text('Save'),
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
                      const SnackBar(content: Text('Podaci uspješno spremljeni!')),
                    );
                    await initForm();
                    setState(() {});
                  } catch (e) {
                    print("Greška prilikom spremanja: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              'Došlo je do pogreške pri spremanju podataka.')),
                    );
                  }
                }
              },
              child: const Text('Unesi novo vozilo u tabelu'),
            ),
          ),
        ],
      ),
    );
  }

  int calculateDayDifference(String periodString) {
    List<String> parts = periodString.split(' ');
    String daysPart = parts[0];
    List<String> numbers = daysPart.split('-');
    int firstDay = int.parse(numbers[0]);
    int secondDay = int.parse(numbers[1]);
    return firstDay * 100 + secondDay;
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

  Widget _buildDataListView() {
    Map<int, List<CijenePoVremenskomPeriodu>> groupedResults = {};
    cijenePoVremenskomPerioduResult?.result.forEach((cijena) {
      if (!groupedResults.containsKey(cijena.voziloId)) {
        groupedResults[cijena.voziloId!] = [];
      }
      groupedResults[cijena.voziloId!]!.add(cijena);
    });
    periodResult?.result.sort((a, b) {
      int daysA = calculateDayDifference(a.trajanje!);
      int daysB = calculateDayDifference(b.trajanje!);
      return daysA.compareTo(daysB);
    });

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            dataRowHeight: 120,
            columns: [
              const DataColumn(
                label: Text(
                  'Vozilo',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              const DataColumn(
                label: Text(
                  'Model',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              const DataColumn(
                label: Text(
                  'Marka',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              ...(periodResult?.result.map<DataColumn>((period) {
                    return DataColumn(
                      label: Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              String? newDuration = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  String currentDuration =
                                      period.trajanje ?? '';
                                  TextEditingController durationController =
                                      TextEditingController(
                                          text: currentDuration);
                                  return AlertDialog(
                                    title: const Text('Uredi trajanje perioda'),
                                    content: TextFormField(
                                      controller: durationController,
                                      decoration: const InputDecoration(
                                          labelText: 'Trajanje perioda'),
                                      validator: _validatePeriod,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(null);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_validatePeriod(
                                                  durationController.text) ==
                                              null) {
                                            Navigator.of(context)
                                                .pop(durationController.text);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Greška'),
                                                  content: Text(_validatePeriod(
                                                      durationController
                                                          .text)!),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('OK'),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (newDuration != null) {
                                setState(() {
                                  period.trajanje = newDuration;
                                });
                                await _periodProvider.update(period.periodId!,
                                    {'trajanje': newDuration});
                              }
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Tooltip(
                                message: "Uredi period",
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(period.trajanje ?? ""),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () async {
                              await _deletePeriod(period.periodId!);
                            },
                            child: const Text('Obriši'),
                          ),
                        ],
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
                      child: SizedBox(
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
                      child: Text(vozilo?.model ?? "",
                          style: const TextStyle(color: Colors.red)),
                    ),
                  ),
                  DataCell(
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        vozilo?.marka ?? "",
                        style: const TextStyle(color: Colors.red),
                      ),
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
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (cijenaZaPeriod.cijena != null)
                                  GestureDetector(
                                    onTap: () async {
                                      double? newPrice = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          double currentPrice =
                                              cijenaZaPeriod.cijena ?? 0.0;
                                          return AlertDialog(
                                            title: const Text('Uredi cijenu'),
                                            content: TextFormField(
                                              decoration: const InputDecoration(
                                                labelText: 'Cijena',
                                                hintText:
                                                    'Format cijene: npr. 67.5',
                                              ),
                                              initialValue:
                                                  currentPrice.toString(),
                                              keyboardType: const TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              onChanged: (value) {
                                                currentPrice =
                                                    double.tryParse(value) ??
                                                        currentPrice;
                                              },
                                              inputFormatters: [
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'^\d*\.?\d{0,1}$')),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(null);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(currentPrice);
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (newPrice != null) {
                                        setState(() {
                                          cijenaZaPeriod.cijena = newPrice;
                                        });
                                        await _cijenePoVremenskomPerioduProvider
                                            .update(
                                                cijenaZaPeriod
                                                    .cijenePoVremenskomPerioduId!,
                                                cijenaZaPeriod);
                                      }
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Tooltip(
                                        message: "Uredi cijenu",
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Text(
                                            cijenaZaPeriod.cijena?.toString() ??
                                                "",
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  ElevatedButton(
                                    onPressed: () async {
                                      var enteredPrice =
                                          await showDialog<double>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Unesi cijenu'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text('Vozilo ID: $voziloId'),
                                                Text(
                                                    'Period ID: ${period.periodId}'),
                                                TextFormField(
                                                  decoration: const InputDecoration(
                                                    labelText: 'Cijena',
                                                    hintText:
                                                        'Format cijene: npr. 67.5',
                                                  ),
                                                  keyboardType: const TextInputType
                                                      .numberWithOptions(
                                                          decimal: true),
                                                  onChanged: (value) {
                                                    _initialValue['cijena'] =
                                                        value;
                                                  },
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d*\.?\d{0,1}$')),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(null);
                                                },
                                                child: const Text('Cancel'),
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
                                                    print('Result: $result');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Podaci uspješno spremljeni!')),
                                                    );
                                                    Navigator.of(context)
                                                        .pop(cijena);
                                                    await initForm();
                                                    setState(() {});
                                                  } catch (e) {
                                                    print(
                                                        'Error while creating new CijenePoVremenskomPeriodu: $e');
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Došlo je do pogreške pri spremanju podataka.')),
                                                    );
                                                  }
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Unesi cijenu'),
                                  ),
                                if (cijenaZaPeriod.cijena != null)
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      await _cijenePoVremenskomPerioduProvider
                                          .delete(cijenaZaPeriod
                                              .cijenePoVremenskomPerioduId!);
                                      setState(() {
                                        cijenaZaPeriod.cijena = null;
                                      });
                                    },
                                  ),
                              ],
                            ),
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
