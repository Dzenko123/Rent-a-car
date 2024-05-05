import 'dart:convert';

import 'package:collection/collection.dart';
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
    final canMoveNext = _startIndex + 3 < (periodResult?.result.length ?? 0);
    final canMovePrevious = _startIndex - 3 >= 0;

    return MasterScreenWidget(
      title_widget: const Text("Cijene vozila"),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 33, 33, 33),
              Color(0xFF333333),
              Color.fromARGB(255, 150, 149, 149),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 10),
                        if (canMovePrevious || canMoveNext)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if (canMovePrevious)
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color.fromARGB(176, 247, 2, 2),
                                          Color.fromARGB(176, 131, 47, 47),
                                          Color.fromARGB(176, 34, 34, 34),
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
                                          Color.fromARGB(176, 34, 34, 34),
                                          Color.fromARGB(176, 47, 131, 51),
                                          Color.fromARGB(176, 10, 247, 2),
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

  int calculateDayDifference(String periodString) {
    List<String> parts = periodString.split(' ');
    String daysPart = parts[0];
    List<String> numbers = daysPart.split('-');
    int firstDay = int.parse(numbers[0]);
    int secondDay = int.parse(numbers[1]);
    return firstDay * 100 + secondDay;
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
      padding: const EdgeInsets.all(2.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            dataRowHeight: 80,
            columns: [
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
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
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Model',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    'Marka',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              ...(displayedPeriods.map<DataColumn>((period) {
                    return DataColumn(
                      label: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1, vertical: 4),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                period.trajanje ?? "",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
                        width: 90,
                        height: 60,
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
                          fontSize: 14,
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
                          fontSize: 14,
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
                            cijene.firstWhereOrNull(
                          (cijena) => cijena.periodId == period.periodId,
                        );
                        return DataCell(
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    cijenaZaPeriod?.cijena?.toString() ?? "/",
                                  ),
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
