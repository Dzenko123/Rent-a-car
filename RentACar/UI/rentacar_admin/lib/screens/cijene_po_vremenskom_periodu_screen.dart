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
  int _startIndex = 0;

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
    final canMoveNext = _startIndex + 3 < (periodResult?.result.length ?? 0);
    final canMovePrevious = _startIndex - 3 >= 0;

    return MasterScreenWidget(
      title_widget: const Text("Cijene vozila"),
      child: Container(
        decoration: const BoxDecoration(
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
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (canMovePrevious || canMoveNext)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (canMovePrevious)
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(130, 247, 2, 2),
                                          Color.fromARGB(130, 131, 47, 47),
                                          Color.fromARGB(130, 34, 34, 34),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(color: Colors.white)),
                                  child: IconButton(
                                    onPressed: () {
                                      _movePrevious();
                                    },
                                    icon: Row(
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "Prethodna stranica",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              SizedBox(
                                width: 30,
                              ),
                              if (canMoveNext)
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(130, 34, 34, 34),
                                          Color.fromARGB(130, 47, 131, 51),
                                          Color.fromARGB(130, 10, 247, 2),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(color: Colors.white)),
                                  child: IconButton(
                                    onPressed: () {
                                      _moveNext();
                                    },
                                    icon: Row(
                                      children: [
                                        Text(
                                          "Sljedeća stranica",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(width: 5),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        isLoading
                            ? Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _buildDataListView(),
                              )
                            : Container(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              )
            ],
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
      padding: const EdgeInsets.only(left: 30, top: 30, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                    _initialValue['cijena'] = null;

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
                            decoration:
                                const InputDecoration(labelText: 'Vozilo'),
                          ),
                          TextFormField(
                            initialValue: minPeriodId.toString(),
                            decoration:
                                const InputDecoration(labelText: 'Period(redni broj)'),
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
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                          child: const Text('Odustani'),
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
                          child: const Text('Spremi'),
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

                  try {
                    var result = await _cijenePoVremenskomPerioduProvider
                        .insert(newCijena);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Podaci uspješno spremljeni!')),
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
    final displayedPeriods =
        periodResult?.result.skip(_startIndex).take(3).toList() ?? [];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            dataRowHeight: 120,
            columns: [
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Vozilo',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Model',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Marka',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              ...(displayedPeriods.map<DataColumn>((period) {
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
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      period.trajanje ?? "",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () async {
                              bool? confirmDelete = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Potvrda brisanja'),
                                    content: const Text(
                                        'Da li ste sigurni da želite obrisati ovaj period?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('Odustani'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('Obriši'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (confirmDelete == true) {
                                await _deletePeriod(period.periodId!);
                              }
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Tooltip(
                                message: "Obriši period",
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ),
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
                      child: Text(
                        vozilo?.model ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        vozilo?.marka ?? "",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ...(displayedPeriods.map<DataCell>((period) {
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
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Cijena',
                                                    hintText:
                                                        'Format cijene: npr. 67.5',
                                                  ),
                                                  keyboardType:
                                                      const TextInputType
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

                                                  try {
                                                    var result =
                                                        await _cijenePoVremenskomPerioduProvider
                                                            .insert(newCijena);
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
                                    tooltip: 'Obriši cijenu',
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

  void _moveNext() {
    setState(() {
      if (_startIndex + 3 < (periodResult?.result.length ?? 0)) {
        _startIndex += 3;
      }
    });
  }

  void _movePrevious() {
    setState(() {
      if (_startIndex - 3 >= 0) {
        _startIndex -= 3;
      }
    });
  }
}
