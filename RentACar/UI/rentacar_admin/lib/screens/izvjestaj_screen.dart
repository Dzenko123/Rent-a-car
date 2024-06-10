import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija_dodatna_usluga.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/providers/dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_dodatna_usluga_provider.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/models/vozila.dart';

class IzvjestajiPage extends StatefulWidget {
    DodatnaUsluga? dodatnaUsluga;

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
   SearchResult<DodatnaUsluga>? dodatnaUslugaResult;
  SearchResult<RezervacijaDodatnaUsluga>? rezervacijaDodatnaUslugaResult;
  List<Rezervacija> _rezervacije = [];
  List<Vozilo> _vozila = [];
  List<Grad> _gradovi = [];
List<Korisnici> _korisnici = []; 
  String _selectedOption = 'Mjesečne rezervacije tokom godine';
late List<DataRow> _dataRows = [];
  @override
  void initState() {
    super.initState();
    _rezervacijaProvider = RezervacijaProvider();
    _vozilaProvider = VozilaProvider();
    _gradProvider = GradProvider();
     _korisniciProvider = KorisniciProvider();
     _dodatnaUslugaProvider=context.read<DodatnaUslugaProvider>();
    _rezervacijaDodatnaUslugaProvider=context.read<RezervacijaDodatnaUslugaProvider>();
    initForm();
  }

  Future<void> initForm() async {
    try {
      _rezervacije = (await _rezervacijaProvider.get()).result;
      _vozila = (await _vozilaProvider.get()).result;
      _gradovi = (await _gradProvider.get()).result;
        _korisnici = (await _korisniciProvider.get()).result;
         dodatnaUslugaResult=await _dodatnaUslugaProvider.get();
    rezervacijaDodatnaUslugaResult=await _rezervacijaDodatnaUslugaProvider.get();
_dataRows = await _buildDataRows(
          _rezervacije, rezervacijaDodatnaUslugaResult?.result ?? []);
      setState(() {});
    } catch (e) {
      print('Greška: $e');}
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Izvještaji'),
    ),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
  _buildDropDown(),
  if (_selectedOption == 'Mjesečne rezervacije tokom godine')
    _buildMonthlyChartsRow(_rezervacije),
  if (_selectedOption == 'Rezervacije po vozilima i gradovima')
    _buildReservationChartsRow(_rezervacije, _vozila),
  if (_selectedOption == 'Ukupna zarada')
    _buildRevenueChartsRow(_rezervacije),
  _buildReservationTable(_rezervacije, rezervacijaDodatnaUslugaResult?.result ?? []),
],

      ),
    ),
  );
}
Widget _buildReservationTable(
      List<Rezervacija> rezervacije,
      List<RezervacijaDodatnaUsluga> rezervacijaDodatnaUsluga) {
    return Padding(
      padding: const EdgeInsets.only(left: 80.0, right: 80, bottom: 30),
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
        ),
        child: DataTable(
          columnSpacing: 20.0,
          columns: [
            DataColumn(label: _buildDataTableCell('Ime')),
            DataColumn(label: _buildDataTableCell('Prezime')),
            DataColumn(label: _buildDataTableCell('Početni datum')),
            DataColumn(label: _buildDataTableCell('Završni datum')),
            DataColumn(label: _buildDataTableCell('Dodatne usluge')),
            DataColumn(label: _buildDataTableCell('Ukupna cijena')),
          ],
          rows: _dataRows,
        ),
      ),
    );
  }

Future<List<DataRow>> _buildDataRows(
      List<Rezervacija> rezervacije,
      List<RezervacijaDodatnaUsluga> rezervacijaDodatnaUsluga) async {
    List<DataRow> dataRows = [];
    for (var rezervacija in rezervacije) {
      var korisnik = _korisnici
          .firstWhere((korisnik) => korisnik.korisnikId == rezervacija.korisnikId);
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


  Widget _buildDropDown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: DropdownButton<String>(
        value: _selectedOption,
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedOption = newValue;
            });
          }
        },
        items: <String>[
          'Mjesečne rezervacije tokom godine',
          'Rezervacije po vozilima i gradovima',
          'Ukupna zarada',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

Widget _buildMonthlyChartsRow(List<Rezervacija> rezervacije) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: _buildMonthlyReservationChart(rezervacije),
      ),
      Expanded(
        child: _buildMonthlyReservationLineChart(rezervacije),
      ),
    ],
  );
}

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Januar';
      case 2:
        return 'Februar';
      case 3:
        return 'Mart';
      case 4:
        return 'April';
      case 5:
        return 'Maj';
      case 6:
        return 'Juni';
      case 7:
        return 'Juli';
      case 8:
        return 'August';
      case 9:
        return 'Septembar';
      case 10:
        return 'Oktobar';
      case 11:
        return 'Novembar';
      case 12:
        return 'Decembar';
      default:
        return '';
    }
  }

  Widget _buildMonthlyReservationChart(List<Rezervacija> rezervacije) {
    Map<int, int> monthlyData = {};
    for (var rezervacija in rezervacije) {
      int month = rezervacija.pocetniDatum!.month;
      monthlyData.update(month, (value) => (value ?? 0) + 1, ifAbsent: () => 1);
    }

    List<ColumnSeries<MapEntry<int, int>, String>> seriesList = [
      ColumnSeries<MapEntry<int, int>, String>(
        dataSource: monthlyData.entries.toList(),
        xValueMapper: (entry, _) => _getMonthName(entry.key),
        yValueMapper: (entry, _) => entry.value.toDouble(),
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
   
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Broj rezervacija'),
              ),
              series: seriesList.cast<CartesianSeries>(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationChartsRow(
      List<Rezervacija> rezervacije, List<Vozilo> vozila) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: _buildMostReservedVehicleChart(rezervacije, vozila)),
          Expanded(child: _buildReservationByCityChart(rezervacije)),
        ],
      ),
    );
  }

  Widget _buildMostReservedVehicleChart(
      List<Rezervacija> rezervacije, List<Vozilo> vozila) {
    Map<String, int> vehicleCount = {};
    for (var rezervacija in rezervacije) {
      String vehicleName = vozila
          .firstWhere((vozilo) => vozilo.voziloId == rezervacija.voziloId)
          .model!;
      vehicleCount.update(vehicleName, (value) => value + 1, ifAbsent: () => 1);
    }

    List<PieSeries<MapEntry<String, int>, String>> seriesList = [
      PieSeries<MapEntry<String, int>, String>(
        dataSource: vehicleCount.entries.toList(),
        xValueMapper: (entry, _) => entry.key,
        yValueMapper: (entry, _) => entry.value,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Broj rezervacija po vozilima',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SfCircularChart(
            series: seriesList.cast<CircularSeries>(),
            legend: Legend(isVisible: true),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationByCityChart(List<Rezervacija> rezervacije) {
    Map<int, int> cityCount = {};
    Map<int, String> cityNames = {};

    GradProvider _gradProvider = GradProvider();
    Future<void> fetchCityNames() async {
      for (var rezervacija in rezervacije) {
        int cityId = rezervacija.gradId!;
        Grad? grad = await _gradProvider.getById(cityId);
        if (grad != null) {
          cityNames[cityId] = grad.naziv!;
        }
      }
    }
    for (var rezervacija in rezervacije) {
      int cityId = rezervacija.gradId!;
      cityCount.update(cityId, (value) => value + 1, ifAbsent: () => 1);
    }
    return FutureBuilder(
      future: fetchCityNames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          List<ColumnSeries<MapEntry<int, int>, String>> seriesList = [
            ColumnSeries<MapEntry<int, int>, String>(
              dataSource: cityCount.entries.toList(),
              xValueMapper: (entry, _) => cityNames[entry.key] ?? 'Nepoznato',
              yValueMapper: (entry, _) => entry.value.toDouble(),
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ];

          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Broj rezervacija po gradovima',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Broj rezervacija'),
                    ),
                    series: seriesList.cast<CartesianSeries>(),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildRevenueChartsRow(List<Rezervacija> rezervacije) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(child: _buildMonthlyRevenueChart(rezervacije)),
          Expanded(child: _buildMonthlyRevenueDoughnutChart(rezervacije)),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueChart(List<Rezervacija> rezervacije) {
    Map<int, double> monthlyRevenue = {};
    for (var rezervacija in rezervacije) {
      int month = rezervacija.pocetniDatum!.month;
      double totalRevenue = rezervacija.totalPrice ?? 0;
      monthlyRevenue.update(month, (value) => (value ?? 0) + totalRevenue, ifAbsent: () => totalRevenue);
    }

    List<BarSeries<MapEntry<int, double>, String>> seriesList = [
      BarSeries<MapEntry<int, double>, String>(
        dataSource: monthlyRevenue.entries.toList(),
        xValueMapper: (entry, _) => _getMonthName(entry.key),
        yValueMapper: (entry, _) => entry.value,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ukupna zarada po mjesecima u KM',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              title: AxisTitle(text: 'Zarada (u KM)'),
            ),
            series: seriesList.cast<CartesianSeries>(),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyRevenueDoughnutChart(List<Rezervacija> rezervacije) {
    Map<int, double> monthlyRevenue = {};
    for (var rezervacija in rezervacije) {
      int month = rezervacija.pocetniDatum!.month;
      double totalRevenue = rezervacija.totalPrice ?? 0;
      monthlyRevenue.update(month, (value) => (value ?? 0) + totalRevenue, ifAbsent: () => totalRevenue);
    }

    List<DoughnutSeries<MapEntry<int, double>, String>> seriesList = [
      DoughnutSeries<MapEntry<int, double>, String>(
        dataSource: monthlyRevenue.entries.toList(),
        xValueMapper: (entry, _) => _getMonthName(entry.key),
        yValueMapper: (entry, _) => entry.value,
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mjesečna zarada (Doughnut)',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 300,
          child: SfCircularChart(
            series: seriesList.cast<CircularSeries>(),
            legend: Legend(isVisible: true),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthlyReservationLineChart(List<Rezervacija> rezervacije) {
    Map<int, int> monthlyData = {};
    for (var rezervacija in rezervacije) {
      int month = rezervacija.pocetniDatum!.month;
      monthlyData.update(month, (value) => (value ?? 0) + 1, ifAbsent: () => 1);
    }

    List<LineSeries<MapEntry<int, int>, String>> seriesList = [
      LineSeries<MapEntry<int, int>, String>(
        dataSource: monthlyData.entries.toList(),
        xValueMapper: (entry, _) => _getMonthName(entry.key),
        yValueMapper: (entry, _) => entry.value.toDouble(),
        dataLabelSettings: DataLabelSettings(isVisible: true),
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
 
          SizedBox(
            height: 300,
            child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Broj rezervacija'),
              ),
              series: seriesList.cast<CartesianSeries>(),
            ),
          ),
        ],
      ),
    );
  }
}
