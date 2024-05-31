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
import 'package:table_calendar/table_calendar.dart';

class VoziloPregledScreen extends StatefulWidget {
  VoziloPregled? voziloPregled;
  Vozilo? vozilo;
  Rezervacija? rezervacija;
  VoziloPregledScreen({super.key, this.vozilo});
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
              Color.fromARGB(255, 33, 33, 33),
              Color(0xFF333333),
              Color.fromARGB(255, 150, 149, 149),
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
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(69, 255, 230, 0),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.car_repair,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            '- Vozilo na popravci',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(69, 255, 230, 0),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.bookmark_add_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Text(
                            '- Vozilo je rezervisano',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
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
          titleTextStyle: const TextStyle(color: Colors.white),
          formatButtonTextStyle: const TextStyle(color: Colors.white),
          leftChevronIcon: const Icon(
            color: Colors.white,
            Icons.chevron_left,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
          formatButtonDecoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(8.0))),
      daysOfWeekStyle: const DaysOfWeekStyle(
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
                  (isSameDay(rezervacija.pocetniDatum!, day) ||
                      day.isAfter(rezervacija.pocetniDatum!)) &&
                  (isSameDay(rezervacija.zavrsniDatum!, day) ||
                      day.isBefore(rezervacija.zavrsniDatum!)))
              .map((rezervacija) => rezervacija.pocetniDatum!);

          return [...pregledi, ...rezervacije].toList();
        } else {
          return [];
        }
      },
      enabledDayPredicate: (day) =>
          day.isAfter(DateTime.now().subtract(const Duration(days: 1))),
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
                (isSameDay(rezervacija.pocetniDatum!, date) ||
                    date.isAfter(rezervacija.pocetniDatum!)) &&
                (isSameDay(rezervacija.zavrsniDatum!, date) ||
                    date.isBefore(rezervacija.zavrsniDatum!)) &&
                date.isAfter(DateTime.now()));
            bool voziloNaPregledu = voziloPregledResult!.result.any((pregled) =>
                pregled.datum != null &&
                isSameDay(pregled.datum!, date) &&
                pregled.voziloId == widget.vozilo!.voziloId);
            bool isToday = isSameDay(date, DateTime.now());
            bool isAfterToday = date.isAfter(DateTime.now());
            if (isAfterToday && !isReserved && !voziloNaPregledu) {
              return Container(
                margin: const EdgeInsets.all(1),
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
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (isReserved) {
              return Container(
                margin: const EdgeInsets.all(1),
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
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            if (!voziloNaPregledu) {
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(16, 158, 158, 158),
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
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(128, 116, 180, 249),
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
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          } else {
            return Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: const Color.fromARGB(166, 158, 158, 158),
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
                        style: const TextStyle(fontSize: 15, color: Colors.white),
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
              rezervacija.voziloId == widget.vozilo!.voziloId &&
              rezervacija.pocetniDatum != null &&
              rezervacija.zavrsniDatum != null &&
              (isSameDay(rezervacija.pocetniDatum!, date) ||
                  date.isAfter(rezervacija.pocetniDatum!)) &&
              (isSameDay(rezervacija.zavrsniDatum!, date) ||
                  date.isBefore(rezervacija.zavrsniDatum!)) &&
              date.isAfter(DateTime.now()));
          bool voziloNaPregledu = voziloPregledResult!.result.any((pregled) =>
              isSameDay(pregled.datum!, date) &&
              pregled.voziloId == widget.vozilo?.voziloId);
          if (isAfterToday && !isReserved && !voziloNaPregledu) {
            return Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 114, 228, 118),
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
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          if (rezervacijaResult != null &&
              rezervacijaResult!.result.isNotEmpty) {
            if (isReserved) {
              return Container(
                margin: const EdgeInsets.all(1),
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
                          style: const TextStyle(fontSize: 15, color: Colors.white),
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
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(128, 116, 180, 249),
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
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (!voziloNaPregledu && !isToday) {
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(128, 116, 180, 249),
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
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ]),
              );
            } else {
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(128, 116, 249, 229),
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
                          style: const TextStyle(
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
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: const Color.fromARGB(128, 116, 180, 249),
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
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: const Color.fromARGB(128, 116, 249, 229),
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
                        style: const TextStyle(
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
            margin: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: const Color.fromARGB(166, 158, 158, 158),
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
                      style: const TextStyle(
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
                  top: 7,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(111, 0, 0, 0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: const Icon(
                        Icons.car_repair,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }
            } else {
              return Positioned(
                top: 7,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: const Icon(
                      Icons.bookmark_add_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
