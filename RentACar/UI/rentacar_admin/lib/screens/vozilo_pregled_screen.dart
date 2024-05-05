import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/models/vozilo_pregled.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/providers/vozilo_pregled_provider.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rentacar_admin/utils/util.dart';

class VoziloPregledScreen extends StatefulWidget {
  VoziloPregled? voziloPregled;
  Vozilo? vozilo;

  VoziloPregledScreen({Key? key, this.vozilo}) : super(key: key);
  @override
  State<VoziloPregledScreen> createState() => _VoziloPregledScreenState();
}

class _VoziloPregledScreenState extends State<VoziloPregledScreen> {
  SearchResult<VoziloPregled>? voziloPregledResult;
  SearchResult<Vozilo>? vozilaResult;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _secondFocusedDay;
  late VoziloPregledProvider _voziloPregledProvider;
  late VozilaProvider _vozilaProvider;
  final TextEditingController _ftsController = TextEditingController();
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'voziloId': widget.voziloPregled?.voziloId.toString(),
      'datum': widget.voziloPregled?.datum,
    };
    _voziloPregledProvider = VoziloPregledProvider();
    _vozilaProvider = VozilaProvider();
    initForm();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Future<void> initForm() async {
    voziloPregledResult = await _voziloPregledProvider.get();
    vozilaResult = await _vozilaProvider.get();
    print("Cijene po vremenskom periodu: $voziloPregledResult");
    print("Vozila: $vozilaResult");
    setState(() {
      isLoading = false;
    });
  }

  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: widget.vozilo != null
          ? 'Pregledate model i marku: ${widget.vozilo?.model}, ${widget.vozilo?.marka}'
          : "Pregledi za sva vozila",
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isLoading ? Container() : _buildForm(),
                      const SizedBox(height: 20),
                      _buildCalendar(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2024, 01, 01),
      lastDay: DateTime.utc(9999, 12, 31),
      calendarFormat: _calendarFormat,
      focusedDay: _focusedDay,
      headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(color: Colors.white),
          formatButtonTextStyle: TextStyle(color: Colors.white),
          leftChevronIcon: Icon(
            color: Colors.white,
            Icons.chevron_left,
          ),
          rightChevronIcon: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          formatButtonDecoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0))),
      daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white),
          weekendStyle: TextStyle(color: Colors.white)),
      selectedDayPredicate: (day) =>
          _secondFocusedDay != null && isSameDay(day, _secondFocusedDay!),
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          if (_secondFocusedDay == null ||
              !isSameDay(selectedDay, _secondFocusedDay!)) {
            _secondFocusedDay = selectedDay;
          } else {
            _secondFocusedDay = null;
          }
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (day) {
        if (widget.vozilo != null && voziloPregledResult != null) {
          return voziloPregledResult!.result
              .where((pregled) =>
                  isSameDay(pregled.datum!, day) &&
                  pregled.voziloId == widget.vozilo!.voziloId)
              .map((pregled) => pregled.datum!)
              .toList();
        } else {
          if (vozilaResult != null && vozilaResult!.result.isNotEmpty) {
            List<DateTime> datumiZaVozila = [];
            for (var vozilo in vozilaResult!.result) {
              var datumiZaVozilo = voziloPregledResult!.result
                  .where((pregled) =>
                      pregled.voziloId == vozilo.voziloId &&
                      isSameDay(pregled.datum!, day))
                  .map((pregled) => pregled.datum!)
                  .toList();
              datumiZaVozila.addAll(datumiZaVozilo);
            }
            return datumiZaVozila;
          }
          return [];
        }
      },
      enabledDayPredicate: (day) =>
          day.isAfter(DateTime.now().subtract(Duration(days: 1))),
      daysOfWeekHeight: 50,
      rowHeight: 70,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          if (widget.vozilo != null && voziloPregledResult != null) {
            bool voziloNaPregledu = voziloPregledResult!.result.any((pregled) =>
                isSameDay(pregled.datum!, date) &&
                pregled.voziloId == widget.vozilo?.voziloId);
            if (!voziloNaPregledu) {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color.fromARGB(16, 158, 158, 158),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      left: 4,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Tooltip(
                          message: "Dodaj vozilo na pregled",
                          child: GestureDetector(
                            onTap: () {
                              _prikaziVoziloDijalog(date);
                            },
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color.fromARGB(16, 158, 158, 158),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      left: 4,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Tooltip(
                          message: "Ukloni pregled vozila",
                          child: GestureDetector(
                            onTap: () {
                              _prikaziBrisanjeVozilaDijalog(date);
                            },
                            child: Icon(
                              Icons.delete_forever_sharp,
                              color: Color.fromARGB(217, 244, 67, 54),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 40,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Tooltip(
                          message: "Uredi pregled vozila",
                          child: GestureDetector(
                            onTap: () {
                              _prikaziEditVoziloDijalog(date);
                            },
                            child: Icon(
                              Icons.edit_calendar,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color.fromARGB(16, 158, 158, 158),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(children: [
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ]));
          }
        },
        selectedBuilder: (context, date, _) {
          bool isToday = isSameDay(date, DateTime.now());

          if (widget.vozilo != null && voziloPregledResult != null) {
            bool voziloNaPregledu = voziloPregledResult!.result.any((pregled) =>
                isSameDay(pregled.datum!, date) &&
                pregled.voziloId == widget.vozilo?.voziloId);
            if (voziloNaPregledu) {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color.fromARGB(128, 116, 180, 249),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 1,
                      left: 4,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Tooltip(
                          message: "Ukloni pregled vozila",
                          child: GestureDetector(
                            onTap: () {
                              _prikaziBrisanjeVozilaDijalog(date);
                            },
                            child: Icon(
                              Icons.delete_forever_sharp,
                              color: Color.fromARGB(196, 220, 35, 22),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      left: 40,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Tooltip(
                          message: "Uredi pregled vozila",
                          child: GestureDetector(
                            onTap: () {
                              _prikaziEditVoziloDijalog(date);
                            },
                            child: Icon(
                              Icons.edit_calendar,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (!voziloNaPregledu && !isToday) {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color.fromARGB(128, 116, 180, 249),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(children: [
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 4,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Tooltip(
                        message: "Dodaj vozilo na pregled",
                        child: GestureDetector(
                          onTap: () {
                            _prikaziVoziloDijalog(date);
                          },
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              );
            } else {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Color.fromARGB(128, 116, 249, 229),
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Center(
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 118, 0, 0)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else if (widget.vozilo == null && !isToday) {
            return Container(
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Color.fromARGB(128, 116, 180, 249),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Color.fromARGB(128, 116, 249, 229),
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 118, 0, 0)),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        todayBuilder: (context, date, _) {
          return Container(
            margin: EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Color.fromARGB(166, 158, 158, 158),
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                          fontSize: 15, color: Color.fromARGB(255, 118, 0, 0)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            var preglediZaDatum = voziloPregledResult!.result
                .where((pregled) => isSameDay(pregled.datum!, date));
            if (preglediZaDatum.isNotEmpty) {
              if (widget.vozilo != null) {
                var voziloId = preglediZaDatum
                    .firstWhere((pregled) =>
                        pregled.voziloId == widget.vozilo!.voziloId)
                    .voziloId;
                return Positioned(
                  top: 10,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(111, 0, 0, 0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Vozilo ID:$voziloId na pregledu',
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              } else {
                if (preglediZaDatum.length > 1) {
                  return Positioned(
                    top: 10,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Pregledi za datum'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...preglediZaDatum.map(
                                      (pregled) => ListTile(
                                        title: Text(
                                            'Vozilo ID: ${pregled.voziloId}'),
                                        subtitle: Text(
                                            'Vrijeme pregleda: ${formatDateTime(pregled.datum!)}'),
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                            20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Zatvori'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  );
                } else {
                  var voziloId = preglediZaDatum.first.voziloId;
                  return Positioned(
                    top: 10,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(111, 0, 0, 0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Vozilo ID:$voziloId na pregledu',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }
              }
            }
          }
          return null;
        },
      ),
    );
  }

  void _prikaziEditVoziloDijalog(DateTime date) async {
    TimeOfDay? initialTime = TimeOfDay.now();
    if (voziloPregledResult != null) {
      var preglediZaDan = voziloPregledResult!.result.where((pregled) =>
          isSameDay(pregled.datum!, date) &&
          pregled.voziloId == widget.vozilo!.voziloId);
      if (preglediZaDan.isNotEmpty) {
        initialTime = TimeOfDay.fromDateTime(preglediZaDan.first.datum!);
      }
    }

    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null) {
      final selectedDateTime = DateTime(date.year, date.month, date.day,
          selectedTime.hour, selectedTime.minute);
      await _azurirajPregledVozila(selectedDateTime);
    }
  }

  Future<void> _azurirajPregledVozila(DateTime selectedDateTime) async {
    if (widget.vozilo != null && voziloPregledResult != null) {
      bool hasReviewForDateTime = voziloPregledResult!.result.any((pregled) =>
          isSameDay(pregled.datum!, selectedDateTime) &&
          pregled.datum!.hour == selectedDateTime.hour &&
          pregled.datum!.minute == selectedDateTime.minute &&
          pregled.voziloId != widget.vozilo!.voziloId);

      if (hasReviewForDateTime) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Greška'),
              content: Text(
                  'Drugo vozilo je već zakazano za pregled u tom terminu.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        var voziloPregledId = voziloPregledResult!.result
            .firstWhere(
                (pregled) => isSameDay(pregled.datum!, selectedDateTime))
            .voziloPregledId;
        if (voziloPregledId != null) {
          var request = {
            'voziloId': widget.vozilo!.voziloId,
            'datum': selectedDateTime.toIso8601String()
          };
          await _voziloPregledProvider.update(voziloPregledId, request);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Vrijeme pregleda uspješno ažurirano!')),
          );
          await initForm();
          setState(() {});
        } else {
          print('Vozilo pregled ID je null.');
        }
      }
    } else {
      print('Vozilo je null ili vozilo pregled rezultat je null.');
    }
  }

  void _prikaziBrisanjeVozilaDijalog(DateTime date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Obrisati vozilo sa pregleda?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ne'),
            ),
            TextButton(
              onPressed: () async {
                await _obrisiSaPregleda(date);
                Navigator.of(context).pop();
              },
              child: Text('Da'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _obrisiSaPregleda(DateTime date) async {
    if (widget.vozilo != null && voziloPregledResult != null) {
      var voziloPregledId = voziloPregledResult!.result
          .firstWhere((pregled) =>
              isSameDay(pregled.datum!, date) &&
              pregled.voziloId == widget.vozilo!.voziloId)
          .voziloPregledId;
      if (voziloPregledId != null) {
        await _voziloPregledProvider.delete(voziloPregledId);
        await initForm();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pregled uspješno obrisan.')),
        );
      } else {
        print('Vozilo pregled ID je null.');
      }
    } else {
      print('Vozilo je null ili vozilo pregled rezultat je null.');
    }
  }

  void _prikaziVoziloDijalog(DateTime date) {
    if (widget.vozilo != null && voziloPregledResult != null) {
      bool hasReviewForDateAndTime = voziloPregledResult!.result.any(
          (pregled) =>
              isSameDay(pregled.datum!, date) &&
              pregled.datum!.hour == date.hour &&
              pregled.datum!.minute == date.minute);

      if (hasReviewForDateAndTime) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Greška'),
              content: Text('Drugo vozilo se pregleda u tom terminu.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Dodajte vozilo na pregled?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Ne'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _odaberiVrijemeIDodajNaPregled(date);
                  },
                  child: Text('Da'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  Future<void> _odaberiVrijemeIDodajNaPregled(DateTime date) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final selectedDateTime = DateTime(date.year, date.month, date.day,
          selectedTime.hour, selectedTime.minute);
      await _dodajNaPregled(selectedDateTime);
    }
  }

  Future<void> _dodajNaPregled(DateTime date) async {
    if (widget.vozilo != null && voziloPregledResult != null) {
      bool hasReviewForDateAndTime = voziloPregledResult!.result.any(
          (pregled) =>
              isSameDay(pregled.datum!, date) &&
              pregled.datum!.hour == date.hour &&
              pregled.datum!.minute == date.minute);

      if (hasReviewForDateAndTime) {
        bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Greška'),
              content: Text('Drugo vozilo se pregleda taj dan.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        final request = {
          'voziloId': widget.vozilo!.voziloId,
          'datum': date.toIso8601String()
        };
        await _voziloPregledProvider.insert(request);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Podaci uspješno spremljeni!')),
        );
        await initForm();
        setState(() {});
      }
    }
  }

  FormBuilder _buildForm() {
    return FormBuilder(
      key: _formKey,
      initialValue: _initialValue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vozilo pregled',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            'Prikazano ID pregleda vozila: ${_getVoziloPregledIdText()}',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            'Prikazano ID vozila: ${_getVoziloIdText()}',
            style: TextStyle(color: Colors.white),
          ),
          Text('Prikazani datumi: ${_getDatumText()}',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  String _getVoziloPregledIdText() {
    if (widget.vozilo != null) {
      if (voziloPregledResult != null &&
          voziloPregledResult!.result.isNotEmpty &&
          voziloPregledResult!.result
              .any((pregled) => pregled.voziloId == widget.vozilo!.voziloId)) {
        var ID = voziloPregledResult!.result
            .where((pregled) => pregled.voziloId == widget.vozilo!.voziloId)
            .map((pregled) => pregled.voziloPregledId.toString())
            .join(', ');
        var count = voziloPregledResult!.result
            .where((pregled) => pregled.voziloId == widget.vozilo!.voziloId)
            .length;
        return '$count, IDs: $ID';
      } else {
        return 'Nema pregleda vozila';
      }
    } else {
      if (voziloPregledResult != null &&
          voziloPregledResult!.result.isNotEmpty) {
        var count = voziloPregledResult!.result.length;
        var IDs = voziloPregledResult!.result
            .map((pregled) => pregled.voziloPregledId.toString())
            .join('; ');
        return '$count, ID-jevi: $IDs';
      } else {
        return 'Nema ID';
      }
    }
  }

  String _getVoziloIdText() {
    if (widget.vozilo != null) {
      return '${widget.vozilo!.voziloId}';
    } else if (vozilaResult != null && vozilaResult!.result.isNotEmpty) {
      var count = vozilaResult!.result.length;

      var IDs = vozilaResult!.result
          .map((vozilo) => vozilo.voziloId.toString())
          .join('; ');
      return '$count, ID-jevi: $IDs';
    }
    return 'Nema dostupnih vozila';
  }

  String _getDatumText() {
    if (widget.vozilo != null) {
      if (voziloPregledResult != null &&
          voziloPregledResult!.result.isNotEmpty &&
          voziloPregledResult!.result
              .any((pregled) => pregled.voziloId == widget.vozilo!.voziloId)) {
        var datumiZaVozilo = voziloPregledResult!.result
            .where((pregled) => pregled.voziloId == widget.vozilo!.voziloId)
            .map((pregled) => formatDateTime(pregled.datum))
            .join('; ');
        return datumiZaVozilo;
      } else {
        return 'Nema datuma';
      }
    } else {
      if (voziloPregledResult != null &&
          voziloPregledResult!.result.isNotEmpty) {
        return voziloPregledResult!.result
            .map((pregled) => formatDateTime(pregled.datum))
            .join('; ');
      } else {
        return 'Nema datuma';
      }
    }
  }
}
