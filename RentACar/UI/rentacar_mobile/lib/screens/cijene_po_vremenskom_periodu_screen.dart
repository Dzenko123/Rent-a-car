import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/cijene_po_vremenskom_periodu.dart';
import 'package:rentacar_admin/models/period.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/cijene_po_vremenskom_periodu_provider.dart';
import 'package:rentacar_admin/providers/period_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';

class CijenePoVremenskomPerioduScreen extends StatefulWidget {
  static const String routeName = "/cijene";

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
    vozilaResult = await _vozilaProvider.getActiveVehicles();

    if (periodResult?.result.isNotEmpty ?? false) {
      minPeriodId = periodResult!.result
          .map((period) => period.periodId!)
          .reduce((a, b) => a < b ? a : b);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final canMoveNext = _startIndex + 3 < (periodResult?.result.length ?? 0);
    final canMovePrevious = _startIndex - 3 >= 0;

    return MasterScreenWidget(
      title_widget: const Text("Cijene vozila"),
      child: Container(
        constraints: BoxConstraints.expand(),
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              isLoading
                  ? Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 20, right: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _buildDataListView(),
                ),
              )
                  : Container(),
              const SizedBox(height: 10),
              if (canMovePrevious || canMoveNext)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
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
                            border: Border.all(color: Colors.white),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _movePrevious();
                            },
                            icon: const Row(
                              children: [
                                Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "Prethodna stranica",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(width: 20),
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
                            border: Border.all(color: Colors.white),
                          ),
                          child: IconButton(
                            onPressed: () {
                              _moveNext();
                            },
                            icon: const Row(
                              children: [
                                Text(
                                  "Sljedeća stranica",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 5),
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
                ),
              const SizedBox(height: 20),
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
    }); final activeVozilaIds = vozilaResult?.result.map((vozilo) => vozilo.voziloId).toSet() ?? {};
    groupedResults.removeWhere((id, _) => !activeVozilaIds.contains(id));

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
                dataRowHeight: 70,
                columnSpacing: 30,
                columns: [
                  DataColumn(
                    label: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: const Text(
                        'Vozilo',
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
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: const Text(
                        'Model',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: const Text(
                        'Marka',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  ...(displayedPeriods.map<DataColumn>((period) {
                        return DataColumn(
                          label: Container(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                period.trajanje ?? "",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                    color: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.selected)) {
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
                            height: 50,
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
                              fontSize: 12,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1.0, 1.0),
                                  blurRadius: 2.0,
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
                              fontSize: 12,
                              shadows: [
                                Shadow(
                                  offset: const Offset(1.0, 1.0),
                                  blurRadius: 2.0,
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
                                        cijenaZaPeriod?.cijena?.toString() ??
                                            "/",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
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
            )));
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
