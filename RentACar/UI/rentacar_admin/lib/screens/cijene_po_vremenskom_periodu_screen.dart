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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
      minPeriodId = periodResult!.result.reduce((a, b) {
        int daysA = calculateDayDifference(a.trajanje!);
        int daysB = calculateDayDifference(b.trajanje!);
        return daysA < daysB ? a : b;
      }).periodId;
    }
    setState(() {});
  }

  Future<void> _deletePeriod(int periodId) async {
    try {
      await _periodProvider.deletePeriod(periodId);
      await initForm();
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Period uspješno obrisan.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Greška prilikom brisanja perioda: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Došlo je do pogreške prilikom brisanja perioda.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteCijena(int voziloId) async {
    try {
      bool success =
          await _cijenePoVremenskomPerioduProvider.deleteByVoziloId(voziloId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Podaci uspješno obrisani!'),
            backgroundColor: Colors.green,
          ),
        );
        await _refreshTable();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Došlo je do pogreške pri brisanju podataka.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _refreshTable() async {
    await initForm();
    setState(() {});
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

                        if (canMovePrevious || canMoveNext)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (canMovePrevious)
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 247, 2, 2),
                                          Color.fromARGB(255, 131, 47, 47),
                                          Color.fromARGB(255, 34, 34, 34),
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
                                          Color.fromARGB(255, 34, 34, 34),
                                          Color.fromARGB(255, 47, 131, 51),
                                          Color.fromARGB(255, 10, 247, 2),
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

                        const SizedBox(height: 10),
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
              child: const Text("Dodaj novi period u tabelu"),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: ElevatedButton(
              onPressed: () async {
                if (availableVehicles.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Sva vozila su već unesena u tabelu'),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  var enteredValues = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (BuildContext context) {
                      _initialValue['cijena'] = null;
                      _initialValue['voziloId'] = null;
                      _initialValue['periodId'] = minPeriodId.toString();
                      final GlobalKey<FormState> _formKey =
                          GlobalKey<FormState>();

                      return AlertDialog(
                        title: const Text('Unesite novo vozilo'),
                        content: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButtonFormField<String>(
                                value: _initialValue['voziloId'] =
                                    availableVehicles.isNotEmpty
                                        ? availableVehicles.first.voziloId
                                            .toString()
                                        : null,
                                items: availableVehicles.map((vozilo) {
                                  return DropdownMenuItem<String>(
                                    value: vozilo.voziloId.toString(),
                                    child: Text(
                                        'Marka: ${vozilo.marka}; model: ${vozilo.model}'),
                                  );
                                }).toList(),
                                onChanged: (String? selectedValue) {
                                  _initialValue['voziloId'] = selectedValue;
                                  _formKey.currentState?.validate();
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Vozilo',
                                  errorMaxLines: 2,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Molimo odaberite vozilo.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                initialValue: periodResult?.result
                                        .firstWhere(
                                          (period) =>
                                              period.periodId == minPeriodId,
                                          orElse: () =>
                                              periodResult!.result.first,
                                        )
                                        .trajanje ??
                                    '',
                                decoration: const InputDecoration(
                                    labelText:
                                        'Trajanje (prvi period iz tabele)'),
                                readOnly: true,
                                onChanged: (value) {
                                  _initialValue['periodId'] =
                                      minPeriodId.toString();
                                  _formKey.currentState?.validate();
                                },
                                validator: (value) {
                                  if (minPeriodId == null) {
                                    return 'Molimo odaberite period.';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Cijena',
                                  hintText: 'Format cijene: npr. 67.55',
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
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
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Odustani'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                Navigator.of(context).pop(_initialValue);
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
                          content: Text('Podaci uspješno spremljeni!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      await initForm();
                      setState(() {});
                    } catch (e) {
                      print("Greška prilikom spremanja: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Došlo je do pogreške pri spremanju podataka.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Unesite novo vozilo u tabelu'),
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
                    'Akcije',
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
                                  final _formKey = GlobalKey<FormState>();
                                  String? errorMessage;

                                  return AlertDialog(
                                    title: const Text('Uredi trajanje perioda'),
                                    content: Form(
                                      key: _formKey,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextFormField(
                                            controller: durationController,
                                            decoration: InputDecoration(
                                              labelText: 'Trajanje perioda',
                                              errorText: errorMessage,
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  !RegExp(r'^\d+-\d+ dana$')
                                                      .hasMatch(value)) {
                                                return 'Format treba biti "n-n dana"';
                                              }

                                              var parts = value.split('-');
                                              var firstDay =
                                                  int.tryParse(parts[0]);
                                              var secondDay = int.tryParse(
                                                  parts[1].split(' ')[0]);

                                              if (firstDay == null ||
                                                  secondDay == null ||
                                                  firstDay >= secondDay) {
                                                return 'Prvi dan treba biti manji od drugog';
                                              }

                                              if (value == currentDuration) {
                                                return 'Novi period isti kao prethodni';
                                              }

                                              bool periodExists =
                                                  displayedPeriods.any((p) =>
                                                      p.trajanje == value);
                                              if (periodExists) {
                                                return 'Uneseni period već postoji!';
                                              }

                                              return null;
                                            },
                                            onChanged: (value) {
                                              final form =
                                                  _formKey.currentState;
                                              if (form != null) {
                                                form.validate();
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 8),
                                          if (errorMessage != null)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Text(
                                                errorMessage!,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(null);
                                        },
                                        child: const Text('Odustani'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          final form = _formKey.currentState!;
                                          if (form.validate()) {
                                            Navigator.of(context)
                                                .pop(durationController.text);
                                          }
                                        },
                                        child: const Text('Spasi'),
                                      ),
                                    ],
                                  );
                                },
                              );

                              if (newDuration != null) {
                                setState(() {
                                  period.trajanje = newDuration;
                                });
                                try {
                                  await _periodProvider.update(period.periodId!,
                                      {'trajanje': newDuration});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Trajanje perioda uspješno ažurirano!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Greška prilikom ažuriranja perioda'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
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
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 8),
                                        RichText(
                                          text: TextSpan(
                                            text: 'OPREZ - ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red,
                                                fontSize: 16),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    ' Da li sigurno želite obrisati cijeli period i podatke vezane za njega?',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
                    Tooltip(
                      message: 'Obriši cijeli redak',
                      child: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          bool? confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Potvrda brisanja'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    RichText(
                                      text: TextSpan(
                                        text: 'OPREZ - ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                            fontSize: 16),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                                ' Da li sigurno želite ukloniti sve podatke iz ovog reda?',
                                            style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 13,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                            await _deleteCijena(voziloId);
                          }
                        },
                      ),
                    ),
                  ),
                  DataCell(
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 180,
                        height: 100,
                        child: vozilo != null && vozilo.slika != null
                            ? _buildImage(vozilo.slika!)
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
                                      double? newPrice =
                                          await showDialog<double>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          double currentPrice =
                                              cijenaZaPeriod.cijena ?? 0.0;
                                          final priceController =
                                              TextEditingController(
                                                  text:
                                                      currentPrice.toString());
                                          final formKey =
                                              GlobalKey<FormState>();

                                          return AlertDialog(
                                            title: const Text('Uredi cijenu'),
                                            content: Form(
                                                key: formKey,
                                                child: TextFormField(
                                                  controller: priceController,
                                                  decoration:
                                                      const InputDecoration(
                                                    labelText: 'Cijena',
                                                    hintText:
                                                        'Format cijene: npr. 67.55',
                                                  ),
                                                  keyboardType:
                                                      const TextInputType
                                                          .numberWithOptions(
                                                          decimal: true),
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  onChanged: (value) {
                                                    _initialValue['cijena'] =
                                                        value;
                                                    _formKey.currentState
                                                        ?.validate();
                                                  },
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'^\d*\.?\d{0,2}$')),
                                                  ],
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Molimo unesite cijenu.';
                                                    }
                                                    if (double.tryParse(
                                                            value) ==
                                                        null) {
                                                      priceController.clear();
                                                      return 'Unesite valjani broj.';
                                                    }
                                                    return null;
                                                  },
                                                )),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(null);
                                                },
                                                child: const Text('Odustani'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  if (formKey.currentState
                                                          ?.validate() ??
                                                      false) {
                                                    Navigator.of(context).pop(
                                                        double.tryParse(
                                                            priceController
                                                                .text));
                                                  }
                                                },
                                                child: const Text('Spasi'),
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
                                          cijenaZaPeriod,
                                        );
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
                                            title: const Text('Unesite cijenu'),
                                            content: Form(
                                              key: _formKey,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text: 'Marka: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '${vozilo!.marka}; ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        TextSpan(
                                                          text: 'model: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '${vozilo.model}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Period trajanja: ',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                        TextSpan(
                                                          text:
                                                              '${period.trajanje ?? ''}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  TextFormField(
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Cijena',
                                                      hintText:
                                                          'Format cijene: npr. 67.55',
                                                    ),
                                                    keyboardType:
                                                        const TextInputType
                                                            .numberWithOptions(
                                                            decimal: true),
                                                    initialValue: '',
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Cijena je obavezna';
                                                      }
                                                      if (double.tryParse(
                                                              value) ==
                                                          null) {
                                                        return 'Unesite validnu cijenu';
                                                      }
                                                      return null;
                                                    },
                                                    onChanged: (value) {
                                                      _initialValue['cijena'] =
                                                          value;
                                                    },
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .allow(RegExp(
                                                              r'^\d*\.?\d{0,2}$')),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(null);
                                                },
                                                child: const Text('Odustani'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  if (_formKey.currentState
                                                          ?.validate() ??
                                                      false) {
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
                                                      await _cijenePoVremenskomPerioduProvider
                                                          .insert(newCijena);
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Podaci uspješno spremljeni!'),
                                                          backgroundColor:
                                                              Colors.green,
                                                        ),
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
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
                                                              'Došlo je do pogreške pri spremanju podataka.'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: const Text('Spasi'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: const Text('Unesite cijenu'),
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

  Widget _buildImage(String base64Image) {
    try {
      final decodedBytes = base64Decode(base64Image);
      if (decodedBytes.isNotEmpty) {
        return Image.memory(
          decodedBytes,
          fit: BoxFit.contain,
        );
      } else {
        return Text('Invalid image data');
      }
    } catch (e) {
      print('Error decoding image: $e');
      return Text('Error loading image');
    }
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
