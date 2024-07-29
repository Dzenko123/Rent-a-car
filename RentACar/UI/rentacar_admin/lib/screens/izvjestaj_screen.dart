import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/rezervacija_dodatna_usluga.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/providers/dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/utils/util.dart';

import '../../models/search_result.dart';
import '../../widgets/master_screen.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class IzvjestajiPage extends StatefulWidget {
  @override
  _IzvjestajiPageState createState() => _IzvjestajiPageState();
}

class _IzvjestajiPageState extends State<IzvjestajiPage> {
  late RezervacijaProvider _rezervacijaProvider;
  late VozilaProvider _vozilaProvider;
  late GradProvider _gradProvider;
  late KorisniciProvider _korisniciProvider;
  late DodatnaUslugaProvider _dodatnaUslugaProvider;
  late RezervacijaDodatnaUslugaProvider _rezervacijaDodatnaUslugaProvider;

  List<Rezervacija> _rezervacije = [];
  List<Vozilo> _vozila = [];
  List<Grad> _gradovi = [];
  List<Korisnici> _korisnici = [];
  List<DodatnaUsluga> _dodatneUsluge = [];
  List<RezervacijaDodatnaUsluga> _rezervacijeDodatneUsluge = [];

  String? _selectedKorisnik = 'Svi korisnici';
  String? _selectedMonth = 'Svi mjeseci';
  String? _selectedYear = 'Sve godine';
  String? _selectedGrad = 'Svi gradovi';

  @override
  void initState() {
    super.initState();
    _rezervacijaProvider = RezervacijaProvider();
    _vozilaProvider = VozilaProvider();
    _gradProvider = GradProvider();
    _korisniciProvider = KorisniciProvider();
    _dodatnaUslugaProvider = context.read<DodatnaUslugaProvider>();
    _rezervacijaDodatnaUslugaProvider =
        context.read<RezervacijaDodatnaUslugaProvider>();
    initForm();
  }

  Future<void> initForm() async {
    try {
      _rezervacije = (await _rezervacijaProvider.get()).result;
      _vozila = (await _vozilaProvider.get()).result;
      _gradovi = (await _gradProvider.get()).result;
      _korisnici = (await _korisniciProvider.get()).result;
      _dodatneUsluge = (await _dodatnaUslugaProvider.get()).result;
      _rezervacijeDodatneUsluge =
          (await _rezervacijaDodatnaUslugaProvider.get()).result;

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Greška: $e');
    }
  }

  List<Rezervacija> getFilteredReservations() {
    List<Rezervacija> filtered = _rezervacije;

    if (_selectedKorisnik != 'Svi korisnici') {
      filtered = filtered
          .where((rezervacija) =>
              rezervacija.korisnikId.toString() == _selectedKorisnik)
          .toList();
    }
    if (_selectedMonth != 'Svi mjeseci') {
      filtered = filtered
          .where((rezervacija) =>
              rezervacija.pocetniDatum?.month.toString() == _selectedMonth)
          .toList();
    }
    if (_selectedYear != 'Sve godine') {
      filtered = filtered
          .where((rezervacija) =>
              rezervacija.pocetniDatum?.year.toString() == _selectedYear)
          .toList();
    }
    if (_selectedGrad != 'Svi gradovi') {
      filtered = filtered
          .where(
              (rezervacija) => rezervacija.gradId?.toString() == _selectedGrad)
          .toList();
    }
    return filtered;
  }

  List<int?> getMonthsWithReservations() {
    if (_selectedYear == 'Sve godine') {
      return _rezervacije
          .map((rezervacija) => rezervacija.pocetniDatum?.month)
          .toSet()
          .toList();
    } else {
      int? selectedYear = int.tryParse(_selectedYear!);
      return _rezervacije
          .where(
              (rezervacija) => rezervacija.pocetniDatum?.year == selectedYear)
          .map((rezervacija) => rezervacija.pocetniDatum?.month)
          .toSet()
          .toList();
    }
  }

  List<Grad> getFilteredGradovi() {
    List<Grad> filteredGradovi = _gradovi;

    if (_selectedKorisnik != 'Svi korisnici') {
      var korisnikId = _selectedKorisnik;
      filteredGradovi = filteredGradovi.where((grad) {
        return _rezervacije.any((rezervacija) =>
            rezervacija.gradId.toString() == grad.gradId.toString() &&
            rezervacija.korisnikId.toString() == korisnikId);
      }).toList();
    }

    if (_selectedMonth != 'Svi mjeseci') {
      var month = int.tryParse(_selectedMonth!);
      filteredGradovi = filteredGradovi.where((grad) {
        return _rezervacije.any((rezervacija) =>
            rezervacija.gradId.toString() == grad.gradId.toString() &&
            rezervacija.pocetniDatum?.month == month);
      }).toList();
    }

    if (_selectedYear != 'Sve godine') {
      var year = int.tryParse(_selectedYear!);
      filteredGradovi = filteredGradovi.where((grad) {
        return _rezervacije.any((rezervacija) =>
            rezervacija.gradId.toString() == grad.gradId.toString() &&
            rezervacija.pocetniDatum?.year == year);
      }).toList();
    }

    return filteredGradovi;
  }

  List<Korisnici> getFilteredUsers() {
    return _korisnici.where((korisnik) {
      return korisnik.uloge?.every((uloga) => uloga.naziv != 'admin') ?? true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Rezervacija> filteredReservations = getFilteredReservations();
    List<int?> monthsWithReservations = getMonthsWithReservations();
    List<Korisnici> filteredUsers = getFilteredUsers();
    List<Grad> gradovi = _gradovi;
    List<Grad> filteredGradovi = getFilteredGradovi();

    return Scaffold(
      appBar: AppBar(
        title: Text('Izvještaji'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        hint: Text(
                          'Odaberi korisnika',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: _selectedKorisnik,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedKorisnik = newValue;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Svi korisnici',
                            child: Text(
                              'Svi korisnici',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...filteredUsers.map((korisnik) {
                            return DropdownMenuItem<String>(
                              value: korisnik.korisnikId.toString(),
                              child:
                                  Text('${korisnik.ime} ${korisnik.prezime}'),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        hint: Text(
                          'Odaberi mjesec',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: _selectedMonth,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedMonth = newValue;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Svi mjeseci',
                            child: Text(
                              'Svi mjeseci',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ...List.generate(12, (index) => index + 1)
                              .map((month) {
                            bool hasReservations =
                                monthsWithReservations.contains(month);
                            return DropdownMenuItem<String>(
                              value: month.toString(),
                              child: Row(
                                children: [
                                  Text(DateFormat.MMM()
                                      .format(DateTime(0, month))),
                                  if (!hasReservations)
                                    Text(
                                      ' (nema rezervacija)',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        hint: Text(
                          'Odaberi godinu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: _selectedYear,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedYear = newValue;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Sve godine',
                            child: Text(
                              'Sve godine',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ..._rezervacije
                              .map((rezervacija) =>
                                  rezervacija.pocetniDatum?.year)
                              .toSet()
                              .toList()
                              .map((year) {
                            return DropdownMenuItem<String>(
                              value: year.toString(),
                              child: Text(year.toString()),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        hint: Text(
                          'Odaberi grad',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        value: _selectedGrad,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedGrad = newValue;
                          });
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'Svi gradovi',
                            child: Text(
                              'Svi gradovi',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ..._gradovi.map((grad) {
                            bool hasReservations = filteredGradovi.any(
                                (filteredGrad) =>
                                    filteredGrad.gradId == grad.gradId);
                            return DropdownMenuItem<String>(
                              value: grad.gradId.toString(),
                              child: Row(
                                children: [
                                  Text(grad.naziv ?? ''),
                                  if (!hasReservations)
                                    Text(
                                      ' (nema rezervacija)',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              switchInCurve: Curves.easeIn,
              switchOutCurve: Curves.easeOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _selectedMonth == null || _selectedMonth == 'Svi mjeseci'
                  ? _buildYearlyBarChart(key: ValueKey('yearly'))
                  : _buildMonthlyLineChart(key: ValueKey('monthly')),
            ),
            SizedBox(height: 16),
            _buildReservationTable(filteredReservations,
                _rezervacijeDodatneUsluge, filteredUsers, _gradovi),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationTable(
    List<Rezervacija> rezervacije,
    List<RezervacijaDodatnaUsluga> rezervacijaDodatnaUsluga,
    List<Korisnici> korisnici,
    List<Grad> gradovi,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 80, bottom: 30),
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: FutureBuilder<List<DataRow>>(
          future: _buildDataRows(
              rezervacije, rezervacijaDodatnaUsluga, korisnici, gradovi),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Došlo je do greške: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('Nema podataka za prikaz.'));
            }

            return DataTable(
              columnSpacing: 20.0,
              columns: [
                DataColumn(label: _buildDataTableCell('Ime')),
                DataColumn(label: _buildDataTableCell('Prezime')),
                DataColumn(label: _buildDataTableCell('Grad')),
                DataColumn(label: _buildDataTableCell('Početni datum')),
                DataColumn(label: _buildDataTableCell('Završni datum')),
                DataColumn(label: _buildDataTableCell('Dodatne usluge')),
                DataColumn(label: _buildDataTableCell('Ukupna cijena')),
              ],
              rows: snapshot.data!,
            );
          },
        ),
      ),
    );
  }

  Future<List<DataRow>> _buildDataRows(
    List<Rezervacija> rezervacije,
    List<RezervacijaDodatnaUsluga> rezervacijaDodatnaUsluga,
    List<Korisnici> korisnici,
    List<Grad> gradovi,
  ) async {
    List<DataRow> dataRows = [];
    for (var rezervacija in rezervacije) {
      var korisnik = korisnici.firstWhere(
          (korisnik) => korisnik.korisnikId == rezervacija.korisnikId);

      var grad = gradovi.firstWhere((grad) => grad.gradId == rezervacija.gradId,
          orElse: () => Grad(null, 'Nepoznato'));

      var rezervacijaUsluge = rezervacijaDodatnaUsluga
          .where((ru) => ru.rezervacijaId == rezervacija.rezervacijaId)
          .toList();
      List<String> uslugeNazivi = [];
      if (rezervacijaUsluge.isNotEmpty) {
        for (var usluga in rezervacijaUsluge) {
          String? naziv = await getDodatnaUslugaNaziv(usluga.dodatnaUslugaId);
          if (naziv != null) {
            uslugeNazivi.add(naziv);
          }
        }
      } else {
        uslugeNazivi.add('/');
      }

      dataRows.add(DataRow(cells: [
        DataCell(_buildDataTableCell(korisnik.ime ?? '')),
        DataCell(_buildDataTableCell(korisnik.prezime ?? '')),
        DataCell(_buildDataTableCell(grad.naziv ?? 'Nepoznato')),
        DataCell(_buildDataTableCell(formatDateTime(rezervacija.pocetniDatum))),
        DataCell(_buildDataTableCell(formatDateTime(rezervacija.zavrsniDatum))),
        DataCell(_buildDataTableCell(uslugeNazivi.join(', '))),
        DataCell(_buildDataTableCell(rezervacija.totalPrice.toString())),
      ]));
    }
    return dataRows;
  }

  Widget _buildDataTableCell(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14.0,
          fontFamily: 'Roboto',
        ),
      ),
    );
  }

  Future<String?> getDodatnaUslugaNaziv(int? dodatnaUslugaId) async {
    if (dodatnaUslugaId != null) {
      var dodatnaUsluga = await _dodatnaUslugaProvider.getById(dodatnaUslugaId);
      return dodatnaUsluga?.naziv;
    }
    return null;
  }

  Widget _buildYearlyBarChart({Key? key}) {
    List<BarChartGroupData> generateBarChartGroups() {
      List<BarChartGroupData> barGroups = [];

      List<Rezervacija> data = getFilteredReservations();

      for (int i = 1; i <= 12; i++) {
        double sum = 0;
        for (var rezervacija in data) {
          if (rezervacija.pocetniDatum?.month == i) {
            sum += rezervacija.totalPrice ?? 0;
          }
        }
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: sum,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(5),
                width: 15,
              ),
            ],
            showingTooltipIndicators: [0],
          ),
        );
      }

      return barGroups;
    }

    return Container(
      key: key,
      height: 500,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: BarChart(
        BarChartData(
          groupsSpace: 15,
          barGroups: generateBarChartGroups(),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            horizontalInterval: 2000,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.shade300,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 2000,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    DateFormat.MMM().format(DateTime(0, value.toInt())),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade600,
                    ),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          minY: 0,
          maxY: 10000,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${DateFormat.MMM().format(DateTime(0, group.x))}\n${rod.toY.toStringAsFixed(2)}',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            touchCallback: (FlTouchEvent event, barTouchResponse) {},
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }

  Widget _buildMonthlyLineChart({Key? key}) {
    List<FlSpot> generateLineChartSpots() {
      List<FlSpot> spots = [];

      List<Rezervacija> data = getFilteredReservations();

      for (int i = 0; i < 31; i++) {
        double sum = 0;
        for (var rezervacija in data) {
          if (rezervacija.pocetniDatum?.day == i + 1) {
            sum += rezervacija.totalPrice ?? 0;
          }
        }
        spots.add(FlSpot(i.toDouble(), sum));
      }

      return spots;
    }

    return Container(
      key: key,
      height: 500,
      padding: const EdgeInsets.all(8.0),
      child: LineChart(
        LineChartData(
          borderData: FlBorderData(
              show: true, border: Border.all(color: Colors.grey, width: 1)),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            drawHorizontalLine: true,
            horizontalInterval: 500,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 0.8,
                dashArray: [5, 5],
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.5),
                strokeWidth: 0.8,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 500,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 500,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 2,
                getTitlesWidget: (double value, TitleMeta meta) {
                  return Text(
                    '${value.toInt() + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ),
          ),
          minX: 0,
          maxX: 30,
          minY: 0,
          maxY: 2000,
          lineBarsData: [
            LineChartBarData(
              spots: generateLineChartSpots(),
              isCurved: true,
              color: Colors.blueAccent,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blueAccent.withOpacity(0.3),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: Colors.blueAccent,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  return LineTooltipItem(
                    '${spot.x.toInt() + 1} dan\n${spot.y.toStringAsFixed(2)}',
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
            touchCallback: (FlTouchEvent event, LineTouchResponse? response) {},
            handleBuiltInTouches: true,
          ),
        ),
      ),
    );
  }
}
