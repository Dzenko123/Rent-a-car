import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
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
import 'package:path/path.dart' as path;

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
  Map<String, Korisnici> korisniciMap = {};
  Map<String, Grad> gradoviMap = {};
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
      Map<String, Korisnici> korisniciMap = {
        for (var korisnik in _korisnici)
          korisnik.korisnikId.toString(): korisnik
      };

      Map<String, Grad> gradoviMap = {
        for (var grad in _gradovi) grad.gradId.toString(): grad
      };

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
    List<Rezervacija> filteredRezervacije = _rezervacije;

    if (_selectedKorisnik != 'Svi korisnici') {
      filteredRezervacije = filteredRezervacije
          .where((rezervacija) =>
              rezervacija.korisnikId.toString() == _selectedKorisnik)
          .toList();
    }

    if (_selectedGrad != 'Svi gradovi') {
      filteredRezervacije = filteredRezervacije
          .where(
              (rezervacija) => rezervacija.gradId.toString() == _selectedGrad)
          .toList();
    }

    if (_selectedYear == 'Sve godine') {
      return filteredRezervacije
          .map((rezervacija) => rezervacija.pocetniDatum?.month)
          .toSet()
          .toList();
    } else {
      int? selectedYear = int.tryParse(_selectedYear!);
      if (selectedYear == null) {
        return [];
      }
      return filteredRezervacije
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
      int? month = _selectedMonth != 'Svi mjeseci'
          ? int.tryParse(_selectedMonth!)
          : null;
      if (month == null) {
        return [];
      }
      filteredGradovi = filteredGradovi.where((grad) {
        return _rezervacije.any((rezervacija) =>
            rezervacija.gradId.toString() == grad.gradId.toString() &&
            rezervacija.pocetniDatum?.month == month);
      }).toList();
    }

    if (_selectedYear != 'Sve godine') {
      int? year =
          _selectedYear != 'Sve godine' ? int.tryParse(_selectedYear!) : null;
      if (year == null) {
        return [];
      }
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

    return MasterScreenWidget(
      title: 'Izvještaji',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
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
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
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
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2.0),
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
                              .where((rezervacija) =>
                                  _selectedKorisnik == 'Svi korisnici' ||
                                  rezervacija.korisnikId.toString() ==
                                      _selectedKorisnik)
                              .map((rezervacija) =>
                                  rezervacija.pocetniDatum?.year)
                              .toSet()
                              .toList()
                              .map((year) {
                            bool hasReservations =
                                _rezervacije.any(
                                    (rezervacija) =>
                                        rezervacija.pocetniDatum?.year ==
                                            year &&
                                        (_selectedMonth == 'Svi mjeseci' ||
                                            rezervacija.pocetniDatum?.month
                                                    .toString() ==
                                                _selectedMonth) &&
                                        (_selectedGrad == 'Svi gradovi' ||
                                            rezervacija.gradId.toString() ==
                                                _selectedGrad));
                            return DropdownMenuItem<String>(
                              value: year.toString(),
                              child: Row(
                                children: [
                                  Text(year.toString()),
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
                  SizedBox(width: 25),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: FractionallySizedBox(
                        widthFactor: 1.2,
                        child: DropdownButton<String>(
                          isExpanded: true,
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
                              bool hasReservations = _rezervacije.any(
                                  (rezervacija) =>
                                      rezervacija.gradId.toString() ==
                                          grad.gradId.toString() &&
                                      (_selectedKorisnik == 'Svi korisnici' ||
                                          rezervacija.korisnikId.toString() ==
                                              _selectedKorisnik) &&
                                      (_selectedMonth == 'Svi mjeseci' ||
                                          rezervacija.pocetniDatum?.month
                                                  .toString() ==
                                              _selectedMonth) &&
                                      (_selectedYear == 'Sve godine' ||
                                          rezervacija.pocetniDatum?.year
                                                  .toString() ==
                                              _selectedYear));
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
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await _generateAndDownloadPdf();
                        },
                        child: Text('Preuzmi PDF'),
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

  String replaceSpecialChars(String input) {
    return input
        .replaceAll('š', 's')
        .replaceAll('č', 'c')
        .replaceAll('ć', 'c')
        .replaceAll('đ', 'd')
        .replaceAll('ž', 'z');
  }

  Future<void> _generateAndDownloadPdf() async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd.MM.yyyy');
    final now = DateTime.now();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(now);

    final selectedYear =
        _selectedYear != 'Sve godine' ? _selectedYear : 'Sve godine';
    final selectedMonth =
        _selectedMonth != 'Svi mjeseci' ? _selectedMonth : 'Svi mjeseci';
    final selectedGrad =
        _selectedGrad != 'Svi gradovi' ? _selectedGrad : 'Svi gradovi';
    final selectedKorisnik = _selectedKorisnik != 'Svi korisnici'
        ? _selectedKorisnik
        : 'Svi korisnici';
    final filteredReservations = getFilteredReservations();
    if (filteredReservations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Nema podataka na osnovu kojih bi se generisao Vaš izvještaj.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    final image = pw.MemoryImage(
      (await rootBundle.load('assets/images/rent.jpg')).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Image(image, width: 400, height: 400),
              pw.SizedBox(height: 20),
              pw.Text(
                'Rent a Car Izvjestaj',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue800,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Korisnik/ci: ',
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Text(
                    '${replaceSpecialChars(_korisnici.firstWhere((k) => k.korisnikId.toString() == selectedKorisnik, orElse: () => Korisnici(null, null, null, null, null, null, null, null, null)).ime ?? 'Svi korisnici')} ${replaceSpecialChars(_korisnici.firstWhere((k) => k.korisnikId.toString() == selectedKorisnik, orElse: () => Korisnici(null, null, null, null, null, null, null, null, null)).prezime ?? '')}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Mjesec/i: ',
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Text(
                    '$selectedMonth',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Godina/e: ',
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Text(
                    '$selectedYear',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Grad/ovi: ',
                    style: pw.TextStyle(
                      fontSize: 16,
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Text(
                    '${replaceSpecialChars(_gradovi.firstWhere((g) => g.gradId.toString() == selectedGrad, orElse: () => Grad(null, null)).naziv ?? 'Svi gradovi')}',
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Izvjestaj generisan na datum: ${dateFormat.format(now)}',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey900,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          final filteredReservations = getFilteredReservations();
          final months = getMonthsWithReservations();
          final groupedByUser = groupByUser(filteredReservations);

          final columnHeaders = <String>['Korisnik'];
          if (selectedMonth != 'Svi mjeseci') {
            final year = selectedYear != null
                ? int.tryParse(selectedYear!)
                : DateTime.now().year;

            if (year != null) {
              columnHeaders.addAll(List.generate(
                  DateTime(year, int.parse(selectedMonth!), 0).day,
                  (index) => (index + 1).toString()));
            } else {
              columnHeaders
                  .addAll(List.generate(31, (index) => (index + 1).toString()));
            }
          } else {
            columnHeaders.addAll([
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec'
            ]);
          }
          columnHeaders.add('Ukupno');

          final rows = groupedByUser.entries.map((entry) {
            final korisnik = entry.key;
            final rezervacije = entry.value;

            List<String> row = [
              '${replaceSpecialChars(korisnik.ime ?? '')}\n${replaceSpecialChars(korisnik.prezime ?? '')}'
            ];

            if (selectedMonth != 'Svi mjeseci') {
              final year = selectedYear != 'Sve godine'
                  ? int.tryParse(selectedYear!)
                  : DateTime.now().year;

              if (year != null) {
                final daysInMonth = List.generate(
                  DateTime(year, int.parse(selectedMonth!), 0).day,
                  (index) => index + 1,
                );
                final dailyPrices = daysInMonth.map((day) {
                  final dailyTotal = rezervacije
                      .where(
                          (rezervacija) => rezervacija.pocetniDatum?.day == day)
                      .map((rezervacija) => rezervacija.totalPrice ?? 0)
                      .fold(0.0, (prev, curr) => prev + curr);
                  return dailyTotal.toStringAsFixed(
                      dailyTotal.truncateToDouble() == dailyTotal ? 0 : 1);
                }).toList();

                final total = dailyPrices
                    .map(double.parse)
                    .fold(0.0, (prev, curr) => prev + curr);
                row.addAll(dailyPrices);

                if (dailyPrices.length < 31) {
                  row.addAll(
                      List.generate(31 - dailyPrices.length, (_) => '0'));
                }

                row.add(total.toStringAsFixed(
                    total.truncateToDouble() == total ? 0 : 1));
              } else {
                row.addAll(List.generate(31, (_) => '0'));
                row.add('0');
              }
            } else {
              final monthlyPrices = List.generate(12, (month) {
                final monthlyTotal = rezervacije
                    .where((rezervacija) =>
                        rezervacija.pocetniDatum?.month == (month + 1))
                    .map((rezervacija) => rezervacija.totalPrice ?? 0)
                    .fold(0.0, (prev, curr) => prev + curr);
                return monthlyTotal.toStringAsFixed(
                    monthlyTotal.truncateToDouble() == monthlyTotal ? 0 : 1);
              });
              final total = monthlyPrices
                  .map(double.parse)
                  .fold(0.0, (prev, curr) => prev + curr);
              row.addAll(monthlyPrices);
              row.add(total
                  .toStringAsFixed(total.truncateToDouble() == total ? 0 : 1));
            }

            final fontSize = selectedMonth == 'Svi mjeseci' ? 10.0 : 7.5;

            return pw.TableRow(
              children: row.asMap().entries.map((entry) {
                final index = entry.key;
                final cell = entry.value;

                return pw.Container(
                  color: index == 0
                      ? PdfColors.grey300
                      : index == row.length - 1
                          ? PdfColors.grey200
                          : PdfColors.cyan100,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(2),
                    child: pw.Text(
                      cell,
                      style: pw.TextStyle(fontSize: fontSize),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList();

          final fontSizeHeader = selectedMonth == 'Svi mjeseci' ? 10.0 : 8.0;
          final columnWidth = selectedMonth != 'Svi mjeseci' ? 25.0 : 35.0;
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              if (selectedMonth != 'Svi mjeseci')
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: pw.FixedColumnWidth(43),
                    for (int i = 1; i <= 31; i++)
                      i: pw.FixedColumnWidth(columnWidth),
                  },
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          alignment: pw.Alignment.center,
                          color: PdfColors.grey300,
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.all(4),
                            child: pw.Text(
                              'Dani u mjesecu po brojevima',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: fontSizeHeader),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.FixedColumnWidth(35),
                  columnHeaders.length - 1: pw.FixedColumnWidth(35),
                },
                children: [
                  pw.TableRow(
                    children: columnHeaders.asMap().entries.map((entry) {
                      final index = entry.key;
                      final header = entry.value;

                      return pw.Container(
                        color: index == 0
                            ? PdfColors.grey300
                            : index == columnHeaders.length - 1
                                ? PdfColors.grey200
                                : PdfColors.grey300,
                        child: pw.Padding(
                          padding: const pw.EdgeInsets.all(1.5),
                          child: pw.Text(
                            header,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: fontSizeHeader),
                            textAlign: pw.TextAlign.center,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  ...rows,
                ],
              ),
            ],
          );
        },
      ),
    );

    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Odaberite mjesto za spremanje PDF-a',
      fileName: 'izvještaj_$timestamp.pdf',
    );

    if (result != null) {
      final outputFile = File(result);
      await outputFile.writeAsBytes(await pdf.save());
      print('PDF preuzet: ${outputFile.path}');
    } else {
      print('Nema odabranog mjesta za spremanje.');
    }
  }

  Map<Korisnici, List<Rezervacija>> groupByUser(
      List<Rezervacija> reservations) {
    final Map<Korisnici, List<Rezervacija>> grouped = {};
    for (var reservation in reservations) {
      final korisnik = _korisnici.firstWhere(
          (k) => k.korisnikId == reservation.korisnikId,
          orElse: () =>
              Korisnici(null, null, null, null, null, null, null, null, null));
      if (!grouped.containsKey(korisnik)) {
        grouped[korisnik] = [];
      }
      grouped[korisnik]?.add(reservation);
    }
    return grouped;
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
