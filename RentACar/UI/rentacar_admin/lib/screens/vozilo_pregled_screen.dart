import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/models/vozilo_pregled.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/providers/vozilo_pregled_provider.dart';
import 'package:rentacar_admin/widgets/master_screen.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:rentacar_admin/utils/util.dart';

class VoziloPregledScreen extends StatefulWidget {
  VoziloPregled? voziloPregled;
  Vozilo? vozilo;
  Rezervacija? rezervacija;

  VoziloPregledScreen({Key? key, this.vozilo}) : super(key: key);
  @override
  State<VoziloPregledScreen> createState() => _VoziloPregledScreenState();
}

class _VoziloPregledScreenState extends State<VoziloPregledScreen> {
  SearchResult<VoziloPregled>? voziloPregledResult;
  SearchResult<Vozilo>? vozilaResult;
  SearchResult<Rezervacija>? rezervacijaResult;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _secondFocusedDay;
  late VoziloPregledProvider _voziloPregledProvider;
  late VozilaProvider _vozilaProvider;
  late RezervacijaProvider _rezervacijaProvider;

  final TextEditingController _ftsController = TextEditingController();
  bool isLoading = true;
  Map<String, dynamic> _initialValue = {};
  final _formKey = GlobalKey<FormBuilderState>();
  Map<int, String> vehicleModelMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initialValue = {
      'voziloId': widget.voziloPregled?.voziloId.toString(),
      'datum': widget.voziloPregled?.datum,
    };
    _voziloPregledProvider = context.read<VoziloPregledProvider>();
    _vozilaProvider = context.read<VozilaProvider>();
    _rezervacijaProvider = context.read<RezervacijaProvider>();

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
    rezervacijaResult = await _rezervacijaProvider.get();
    if (vozilaResult != null) {
      vehicleModelMap = Map.fromIterable(
        vozilaResult!.result,
        key: (v) => v.voziloId!,
        value: (v) => v.model ?? 'Unknown Model',
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
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

  List<DateTime> getReservedDatesForVehicle(
      DateTime startDate, DateTime endDate) {
    if (rezervacijaResult != null) {
      return rezervacijaResult!.result
          .where((rezervacija) =>
              rezervacija.voziloId == widget.vozilo?.voziloId &&
              (rezervacija.pocetniDatum!.isBefore(endDate) ||
                  rezervacija.pocetniDatum!.isAtSameMomentAs(endDate)) &&
              (rezervacija.zavrsniDatum!.isAfter(startDate) ||
                  rezervacija.zavrsniDatum!.isAtSameMomentAs(startDate)))
          .map((rezervacija) => rezervacija.pocetniDatum!)
          .toList();
    }
    return [];
  }

  Widget _buildCalendar() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

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
        } else if (widget.vozilo != null &&
            voziloPregledResult != null &&
            rezervacijaResult != null) {
          var pregledi = voziloPregledResult!.result
              .where((pregled) =>
                  isSameDay(pregled.datum!, day) &&
                  pregled.voziloId == widget.vozilo!.voziloId)
              .map((pregled) => pregled.datum!);

          var rezervacije = rezervacijaResult!.result
              .where((rezervacija) =>
                  rezervacija.voziloId == widget.vozilo!.voziloId &&
                  (isSameDay(rezervacija.pocetniDatum!, day) ||
                      day.isAfter(rezervacija.pocetniDatum!)) &&
                  (isSameDay(rezervacija.zavrsniDatum!, day) ||
                      day.isBefore(rezervacija.zavrsniDatum!)))
              .map((rezervacija) => rezervacija.pocetniDatum!);

          return [...pregledi, ...rezervacije].toList();
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
            bool isReserved = rezervacijaResult!.result.any((rezervacija) =>
                rezervacija.voziloId == widget.vozilo!.voziloId &&
                rezervacija.pocetniDatum != null &&
                rezervacija.zavrsniDatum != null &&
                (isSameDay(rezervacija.pocetniDatum!, date) ||
                    date.isAfter(rezervacija.pocetniDatum!)) &&
                (isSameDay(rezervacija.zavrsniDatum!, date) ||
                    date.isBefore(rezervacija.zavrsniDatum!)) &&
                date.isAfter(DateTime.now()));
            bool isToday = isSameDay(date, DateTime.now());
            bool isAfterToday = date.isAfter(DateTime.now());

            if (isAfterToday && !voziloNaPregledu && !isReserved) {
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
            } else if (voziloNaPregledu && !isReserved) {
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
                      left: 3,
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
                              size: 28,
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
                              size: 23,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (!voziloNaPregledu && isReserved) {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 245, 104, 94),
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
            bool isAfterToday = date.isAfter(DateTime.now());
            bool isReserved = rezervacijaResult!.result.any((rezervacija) =>
                rezervacija.voziloId == widget.vozilo!.voziloId &&
                rezervacija.pocetniDatum != null &&
                rezervacija.zavrsniDatum != null &&
                (isSameDay(rezervacija.pocetniDatum!, date) ||
                    date.isAfter(rezervacija.pocetniDatum!)) &&
                (isSameDay(rezervacija.zavrsniDatum!, date) ||
                    date.isBefore(rezervacija.zavrsniDatum!)) &&
                date.isAfter(DateTime.now()));

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
            } else if (isReserved) {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
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
                var model = vehicleModelMap[voziloId] ?? 'Unknown Model';
                return Positioned(
                  top: 2,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(111, 0, 0, 0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Text(
                        'Pregled modela: $model\nVrijeme: ${formatTime(preglediZaDatum.first.datum!)}',
                        style: TextStyle(color: Colors.white, fontSize: 13),
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
                                title: Text('Svi pregledi na ovaj dan'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...preglediZaDatum.map(
                                      (pregled) {
                                        var voziloId = pregled.voziloId!;
                                        var model = vehicleModelMap[voziloId] ??
                                            'Unknown Model';
                                        return ListTile(
                                          title: RichText(
                                            text: TextSpan(
                                              text: 'Vozilo model: ',
                                              style:
                                                  DefaultTextStyle.of(context)
                                                      .style,
                                              children: <TextSpan>[
                                                TextSpan(
                                                  text: model,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          subtitle: Text(
                                              'Vrijeme pregleda: ${formatTime(pregled.datum!)}'),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 20),
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
                  var model = vehicleModelMap[voziloId] ?? 'Unknown Model';
                  return Positioned(
                    top: 4,
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(111, 0, 0, 0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Pregled modela: $model\nVrijeme:${formatTime(preglediZaDatum.first.datum!)}',
                          style: TextStyle(color: Colors.white, fontSize: 13),
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
    TimeOfDay initialTime = TimeOfDay.now();

    if (voziloPregledResult != null) {
      var preglediZaDan = voziloPregledResult!.result.where((pregled) =>
          isSameDay(pregled.datum!, date) &&
          pregled.voziloId == widget.vozilo!.voziloId);
      if (preglediZaDan.isNotEmpty) {
        initialTime = TimeOfDay.fromDateTime(preglediZaDan.first.datum!);
      }
    }

    await _odaberiVrijemeIazurirajPregled(date, initialTime);
  }

  Future<void> _odaberiVrijemeIazurirajPregled(
      DateTime date, TimeOfDay initialTime) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selectedTime != null) {
      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        selectedTime.hour,
        selectedTime.minute,
      );

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
                    _odaberiVrijemeIazurirajPregled(date, initialTime);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        await _azurirajPregledVozila(selectedDateTime);
      }
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
              content: Text('Vrijeme pregleda uspješno ažurirano!'),
              backgroundColor: Colors.green,
            ),
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
          title: Text('Sigurno želite poništiti pregled ovog vozila?'),
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
          const SnackBar(
            content: Text('Pregled uspješno obrisan.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Vozilo pregled ID je null.');
      }
    } else {
      print('Greška prilikom brisanja.');
    }
  }

  void _prikaziVoziloDijalog(DateTime date) async {
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
                    _odaberiVrijemeIDodajNaPregled(date);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        await _odaberiVrijemeIDodajNaPregled(date);
      }
    }
  }

  Future<void> _odaberiVrijemeIDodajNaPregled(DateTime date) async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      final selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        selectedTime.hour,
        selectedTime.minute,
      );

      bool hasConflict = rezervacijaResult!.result.any(
        (rezervacija) =>
            isSameDay(rezervacija.pocetniDatum!, selectedDateTime) &&
            rezervacija.pocetniDatum!.hour == selectedDateTime.hour &&
            rezervacija.pocetniDatum!.minute == selectedDateTime.minute,
      );

      if (hasConflict) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Termin zauzet'),
              content: Text(
                  'Odabrani termin je već zauzet. Molimo odaberite drugi termin.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _odaberiVrijemeIDodajNaPregled(date);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        await _dodajNaPregled(selectedDateTime);
      }
    }
  }

  Future<void> _dodajNaPregled(DateTime date) async {
    if (widget.vozilo != null && voziloPregledResult != null) {
      bool hasReviewForDateAndTime = voziloPregledResult!.result.any(
        (pregled) =>
            isSameDay(pregled.datum!, date) &&
            pregled.datum!.hour == date.hour &&
            pregled.datum!.minute == date.minute,
      );

      if (hasReviewForDateAndTime) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Greška'),
              content: Text(
                  'Drugo vozilo se pregleda u istom terminu. Odaberite novi.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _odaberiVrijemeIDodajNaPregled(date);
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
          'datum': date.toIso8601String(),
        };
        await _voziloPregledProvider.insert(request);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Podaci uspješno spremljeni!'),
              backgroundColor: Colors.green),
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
          const SizedBox(height: 20),
          Builder(
            builder: (context) {
              String pregledText = _getVoziloPregledIdText();
              return Text(
                pregledText == 'Nema aktivnih pregleda vozila' ||
                        pregledText == 'Nema pregleda u narednim periodima.' ||
                        pregledText == 'Nema pregleda.'
                    ? pregledText
                    : (widget.vozilo != null
                        ? 'Broj pregleda za ovo vozilo: $pregledText'
                        : 'Ukupan broj pregleda svih vozila: $pregledText'),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              );
            },
          ),
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
        var futurePregledi = voziloPregledResult!.result
            .where((pregled) =>
                pregled.voziloId == widget.vozilo!.voziloId &&
                pregled.datum!.isAfter(DateTime.now()))
            .toList();
        if (futurePregledi.isNotEmpty) {
          var count = futurePregledi.length;
          var dates = futurePregledi
              .map((pregled) =>
                  pregled.datum!.toLocal().toString().split(' ')[0])
              .join(', ');
          return '$count\nDatumi: $dates';
        } else {
          return 'Nema aktivnih pregleda vozila';
        }
      } else {
        return 'Nema aktivnih pregleda vozila';
      }
    } else {
      if (voziloPregledResult != null &&
          voziloPregledResult!.result.isNotEmpty) {
        var futurePregledi = voziloPregledResult!.result
            .where((pregled) => pregled.datum!.isAfter(DateTime.now()))
            .toList();
        if (futurePregledi.isNotEmpty) {
          var count = futurePregledi.length;
          var dates = futurePregledi
              .map((pregled) =>
                  pregled.datum!.toLocal().toString().split(' ')[0])
              .join(', ');
          return '$count\nDatumi: $dates';
        } else {
          return 'Nema pregleda u narednim periodima.';
        }
      } else {
        return 'Nema pregleda.';
      }
    }
  }
}
