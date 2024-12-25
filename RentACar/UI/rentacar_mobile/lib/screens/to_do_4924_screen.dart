import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/to_do_4924_provider.dart';
import 'package:rentacar_admin/screens/to_do_4924_novi_screen.dart';

import '../models/search_result.dart';
import '../models/to_do_4924.dart';
import '../widgets/master_screen.dart';

class ToDo4924ListScreen extends StatefulWidget {
  static const String routeName = "/ToDo4924";

  ToDo4924ListScreen({super.key});

  @override
  _ToDo4924ListScreenState createState() => _ToDo4924ListScreenState();
}

class _ToDo4924ListScreenState extends State<ToDo4924ListScreen> {
  late ToDo4924ModelProvider _toDo4924Provider;
  List<ToDo4924Model>? ToDo4924;
  String? selectedStatusValue;
  SearchResult<Korisnici>? userResult;
  late KorisniciProvider _accountProvider;
  DateTime? _datumOd;
  DateTime? _datumDo;

  @override
  void initState() {
    super.initState();
    _toDo4924Provider = context.read<ToDo4924ModelProvider>();
    _accountProvider = context.read<KorisniciProvider>();
    _loadData();
  }

  _loadData() async {
    try {
      userResult = await _accountProvider.get();
      var toDoData = await _toDo4924Provider.get();

      setState(() {
        ToDo4924 = toDoData.result;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void _searchByDate() async {
    var filter = {};

    if (_datumDo != null) {
      filter['DatumPocetka'] = _datumDo?.toIso8601String();
    }

    var data = await _toDo4924Provider.get(filter: filter);

    setState(() {
      ToDo4924 = data.result;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (ToDo4924 != null && ToDo4924!.isNotEmpty)
                    _buildHeading('To do 4924'),
                  _buildSearch(),
                  _buildToDo4924(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ToDo4924NoviScreen()),
            ).then((_) => _loadData());
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DropdownButton<String>(
            value: selectedStatusValue,
            hint: Text('Select user'),
            onChanged: (newValue) async {
              setState(() {
                selectedStatusValue = newValue;
              });
              var filter = {
                'korisnikId': selectedStatusValue
              };

              if (selectedStatusValue == null) {
                filter['korisnikId'] = null;
              }

              var data = await _toDo4924Provider.get(filter: filter);

              setState(() {
                ToDo4924 = data.result;
              });
            },
            items: [
              DropdownMenuItem<String>(
                value: null,
                child: Text('All users'),
              ),
              ...?userResult?.result.map((item) {
                return DropdownMenuItem<String>(
                  value: item.korisnikId.toString(),
                  child: Text(item.ime.toString()),
                );
              }).toList(),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Datum do',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _datumDo = pickedDate;
                      });
                    }
                  },
                  controller: TextEditingController(
                    text: _datumDo != null
                        ? DateFormat('dd.MM.yyyy').format(_datumDo!)
                        : '',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _searchByDate,
            child: Text('Pretraži'),
          ),
        ],
      ),
    );
  }


  Widget _buildHeading(String heading) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Text(
        heading,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildToDo4924() {
    if (ToDo4924 == null || ToDo4924!.isEmpty) {
      return Center(
        child: Text(
          'No data',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      children: ToDo4924!.map((ToDo4924Model toDo4924) {
        String korisnikIme = toDo4924.korisnik?.ime ?? "Unknown";
        String nazivAktivnosti = toDo4924.nazivAktivnosti ?? "N/A";
        String opisAktivnosti = toDo4924.opisAktivnosti ?? "N/A";
        String datumIzvrsenja = toDo4924.datumIzvrsenja != null
            ? DateFormat('dd.MM.yyyy').format(toDo4924.datumIzvrsenja!)
            : "N/A";
        String status = toDo4924.status ?? "N/A";

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text('Ime korisnika: $korisnikIme'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Naziv aktivnosti: $nazivAktivnosti'),
                Text('Opis aktivnosti: $opisAktivnosti'),
                Text('Datum izvršenja: $datumIzvrsenja'),
                Text('Status: $status'),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ToDo4924NoviScreen(
                    ToDo4924: toDo4924,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }


}
