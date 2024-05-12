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
    print("Cijene po vremenskom periodu: $voziloPregledResult");
    print("Vozila: $vozilaResult");
    print('Rezervacije: $rezervacijaResult');
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vozilo != null
            ? '${widget.vozilo?.model}, ${widget.vozilo?.marka}'
            : "Pregledi za sva vozila"),
      ),
      body: Container(
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
                      Container(),
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
        if (widget.vozilo != null &&
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
                  (day.isAfter(rezervacija.pocetniDatum!) ||
                      day.isAtSameMomentAs(rezervacija.pocetniDatum!)) &&
                  (day.isBefore(rezervacija.zavrsniDatum!) ||
                      day.isAtSameMomentAs(rezervacija.zavrsniDatum!)))
              .map((rezervacija) => rezervacija.pocetniDatum!)
              .where((rezervacijaDatum) => rezervacijaDatum.isAfter(
                  DateTime.now().subtract(Duration(
                      days:
                          1)))); // filtriranje samo za današnji dan i buduće datume

          return [...pregledi, ...rezervacije].toList();
        } else {
          return [];
        }
      },
      enabledDayPredicate: (day) =>
          day.isAfter(DateTime.now().subtract(Duration(days: 1))),
      daysOfWeekHeight: 50,
      rowHeight: 70,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          if (rezervacijaResult != null &&
              voziloPregledResult != null &&
              widget.vozilo != null) {
            bool isReserved = rezervacijaResult!.result.any((rezervacija) =>
                rezervacija.voziloId == widget.vozilo!.voziloId &&
                rezervacija.pocetniDatum != null &&
                rezervacija.zavrsniDatum != null &&
                date.isAfter(rezervacija.pocetniDatum!) &&
                date.isBefore(rezervacija.zavrsniDatum!) &&
                date.isAfter(DateTime
                    .now())); // Provjerava da li je rezervacija za današnji dan ili buduće datume
            bool voziloNaPregledu = voziloPregledResult!.result.any((pregled) =>
                pregled.datum != null &&
                isSameDay(pregled.datum!, date) &&
                pregled.voziloId == widget.vozilo!.voziloId);
            bool isToday = isSameDay(date, DateTime.now());
            bool isAfterToday = date.isAfter(DateTime.now());
            if (isAfterToday && !isReserved && !voziloNaPregledu) {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.green,
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
            if (isReserved) {
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
            }
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
                  ],
                ),
              );
            } else {
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
            }
          } else {
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
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
        selectedBuilder: (context, date, _) {
          bool isToday = isSameDay(date, DateTime.now());
          bool isAfterToday = date.isAfter(DateTime.now());
          bool isReserved = rezervacijaResult!.result.any((rezervacija) =>
              rezervacija.voziloId == widget.vozilo?.voziloId &&
              date.isAfter(rezervacija.pocetniDatum!) &&
              date.isBefore(rezervacija.zavrsniDatum!));
          bool voziloNaPregledu = voziloPregledResult!.result.any((pregled) =>
              isSameDay(pregled.datum!, date) &&
              pregled.voziloId == widget.vozilo?.voziloId);
          if (isAfterToday && !isReserved && !voziloNaPregledu) {
            return Container(
              margin: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 114, 228, 118),
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
          if (rezervacijaResult != null &&
              rezervacijaResult!.result.isNotEmpty) {
            if (isReserved && !isToday) {
              return Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 128, 119),
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
          }
          if (widget.vozilo != null && voziloPregledResult != null) {
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
            var preglediZaDatum = voziloPregledResult!.result.where((pregled) =>
                isSameDay(pregled.datum!, date) &&
                pregled.voziloId == widget.vozilo?.voziloId);
            if (preglediZaDatum.isNotEmpty) {
              if (widget.vozilo != null) {
                return Positioned(
                  top: 10,
                  child: Center(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color.fromARGB(111, 0, 0, 0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.car_repair,
                          color: Colors.white,
                        )),
                  ),
                );
              }
            }
          }
          return null;
        },
      ),
    );
  }
}
