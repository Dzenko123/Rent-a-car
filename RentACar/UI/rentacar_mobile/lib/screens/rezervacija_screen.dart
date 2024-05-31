import 'dart:convert';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rentacar_admin/models/cijene_po_vremenskom_periodu.dart';
import 'package:rentacar_admin/models/dodatna_usluga.dart';
import 'package:rentacar_admin/models/grad.dart';
import 'package:rentacar_admin/models/korisnici.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/rezervacija_dodatna_usluga.dart';
import 'package:rentacar_admin/models/search_result.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/models/vozilo_pregled.dart';
import 'package:rentacar_admin/providers/cijene_po_vremenskom_periodu_provider.dart';
import 'package:rentacar_admin/providers/dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/grad_provider.dart';
import 'package:rentacar_admin/providers/korisnici_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_dodatna_usluga_provider.dart';
import 'package:rentacar_admin/providers/rezervacija_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/providers/vozilo_pregled_provider.dart';
import 'package:rentacar_admin/screens/vozila_list_screen.dart';
import 'package:rentacar_admin/utils/util.dart';
import 'package:table_calendar/table_calendar.dart';

class RezervacijaScreen extends StatefulWidget {

  Rezervacija? rezervacija;
  Vozilo? vozilo;
  Korisnici? korisnik;
  VoziloPregled? voziloPregled;

  RezervacijaScreen({super.key, this.vozilo, this.korisnik});

  @override
  State<RezervacijaScreen> createState() => _RezervacijaScreenState();
}

class _RezervacijaScreenState extends State<RezervacijaScreen> {
  SearchResult<Rezervacija>? rezervacijaResult;
  SearchResult<Korisnici>? korisniciResult;
  SearchResult<Vozilo>? vozilaResult;
  SearchResult<VoziloPregled>? voziloPregledResult;
  SearchResult<Grad>? gradResult;
  SearchResult<DodatnaUsluga>? dodatnaUslugaResult;
  SearchResult<RezervacijaDodatnaUsluga>? rezervacijaDodatnaUslugaResult;

  late RezervacijaProvider _rezervacijaProvider;
  late KorisniciProvider _korisniciProvider;
  late VozilaProvider _vozilaProvider;
  late CijenePoVremenskomPerioduProvider _cijenePoVremenskomPerioduProvider;
  late VoziloPregledProvider _voziloPregledProvider;
  late GradProvider _gradProvider;
  late DodatnaUslugaProvider _dodatnaUslugaProvider;
  late RezervacijaDodatnaUslugaProvider _rezervacijaDodatnaUslugaProvider;

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  bool isLoading = true;
  final TextEditingController _ftsController = TextEditingController();
  int? ulogovaniKorisnikId;
  final _formKey = GlobalKey<FormBuilderState>();
  Map<String, dynamic> _initialValue = {};
  bool isEditing = false;
  List<CijenePoVremenskomPeriodu> _cijenePoVremenskomPerioduList = [];
  CijenePoVremenskomPeriodu? _selectedPeriod;
  Uint8List? _imageBytes;
  bool isStartDateSelected = false;
  bool isInfoVisible = false;
  final bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _initialValue = {
      'ime': widget.korisnik?.ime,
      'prezime': widget.korisnik?.prezime,
      'email': widget.korisnik?.email,
      'telefon': widget.korisnik?.telefon,
    };

    _rezervacijaProvider = context.read<RezervacijaProvider>();
    _korisniciProvider = context.read<KorisniciProvider>();
    _vozilaProvider = context.read<VozilaProvider>();
    _cijenePoVremenskomPerioduProvider =
        context.read<CijenePoVremenskomPerioduProvider>();
    _voziloPregledProvider = context.read<VoziloPregledProvider>();
    _gradProvider = context.read<GradProvider>();
    _dodatnaUslugaProvider=context.read<DodatnaUslugaProvider>();
    _rezervacijaDodatnaUslugaProvider=context.read<RezervacijaDodatnaUslugaProvider>();

    getUlogovaniKorisnikId();

    initForm();
    _loadImage();
  }

  Future<void> getUlogovaniKorisnikId() async {
    try {
      var ulogovaniKorisnik = await _korisniciProvider.getLoged(
        Authorization.username ?? '',
        Authorization.password ?? '',
      );
      if (mounted) {
        setState(() {
          ulogovaniKorisnikId = ulogovaniKorisnik;
          if (ulogovaniKorisnikId != null) {
            getKorisnikData(ulogovaniKorisnikId!);
          }
        });
      }
    } catch (e) {
      print('Greška prilikom dobijanja ID-a ulogovanog korisnika: $e');
    }
  }

  void _loadImage() {
    if (widget.vozilo != null && widget.vozilo!.slika != null) {
      if (mounted) {
        setState(() {
          _imageBytes = base64Decode(widget.vozilo!.slika!);
        });
      }
    }
  }

  Future<void> getKorisnikData(int korisnikId) async {
    try {
      var result = await _korisniciProvider.getById(korisnikId);
      if (mounted) {
        setState(() {
          widget.korisnik = result;
        });
      }
    } catch (e) {
      print('Greška prilikom dobijanja podataka o korisniku: $e');
    }
  }

  Future<void> initForm() async {
    try {
      rezervacijaResult = await _rezervacijaProvider.get();
      korisniciResult = await _korisniciProvider.get();
      vozilaResult = await _vozilaProvider.get();
      voziloPregledResult = await _voziloPregledProvider.get();
      gradResult = await _gradProvider.get();
      dodatnaUslugaResult=await _dodatnaUslugaProvider.get();
      rezervacijaDodatnaUslugaResult=await _rezervacijaDodatnaUslugaProvider.get();

      print('$vozilaResult');
      print('${widget.vozilo?.voziloId}');
      print('$gradResult');
      print('$dodatnaUslugaResult');

      final cijenePoVremenskomPerioduResult =
      await _cijenePoVremenskomPerioduProvider
          .getByVoziloId(widget.vozilo?.voziloId ?? 0);
      if (mounted) {
        setState(() {
          _cijenePoVremenskomPerioduList = cijenePoVremenskomPerioduResult;
        });
        print('CijenePoVremenskomPeriodu: $cijenePoVremenskomPerioduResult');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _ftsController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rezervacija za voziloId: ${widget.vozilo?.voziloId}"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildImagePreview(),
              const SizedBox(height: 20),
              _buildDataListView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageBytes != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          height: 160,
          width: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              _imageBytes!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildDataListView() {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        autovalidateMode:
            _autoValidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        child: Column(
          children: [
            const SizedBox(height: 10),
            if (widget.korisnik != null) ...[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: _buildInfoRow(
                    Icons.person_pin, 'Ime', widget.korisnik!.ime),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: _buildInfoRow(
                    Icons.person_pin, 'Prezime', widget.korisnik!.prezime),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: _buildInfoRow(
                    Icons.email, 'Email:', widget.korisnik!.email),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: _buildInfoRow(
                    Icons.phone, 'Telefon:', widget.korisnik!.telefon),
              ),
              IconButton(
                icon: const Icon(Icons.info),
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    isInfoVisible = !isInfoVisible;
                  });
                },
              ),
              Visibility(
                visible: isInfoVisible,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Vaše podatke možete urediti na stavci "Profil"!',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ] else ...[
              const CircularProgressIndicator(),
            ],
            _buildGradDropdown(),
            _buildDodatnaUslugaDropdown(),

            const SizedBox(height: 10),

            _buildPeriodDropdown(),
            if (_selectedStartDate != null || _selectedEndDate != null) ...[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (_selectedStartDate != null) ...[
                      FormBuilderTextField(
                        name: 'pocetniDatum',
                        decoration: InputDecoration(
                          labelText:
                              'Start Date: ${DateFormat('yyyy-MM-dd').format(_selectedStartDate!)}',
                        ),
                        initialValue: DateFormat('yyyy-MM-dd')
                            .format(_selectedStartDate!),
                        readOnly: true,
                      ),
                    ],
                    if (_selectedEndDate != null) ...[
                      FormBuilderTextField(
                        name: 'zavrsniDatum',
                        decoration: const InputDecoration(
                          labelText: 'End Date',
                        ),
                        initialValue:
                            DateFormat('yyyy-MM-dd').format(_selectedEndDate!),
                        readOnly: true,
                      ),
                    ],
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                         resetSelectedDates();
                          _selectedPeriod = null;
                        });
                      },
                      child: const Text('Očisti odabrani period'),
                    ),
                  ],
                ),
              ),
            ],Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Ukupna cijena: ${_calculateTotalPrice().toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showConfirmationDialog(_calculateTotalPrice());
              },
              child: const Text('Potvrdi rezervaciju'),
            ),

          ],
        ),
      ),
    );
  }
  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    _selectedDodatneUsluge.clear();
    if (_formKey.currentState != null &&
        _formKey.currentState!.fields['dodatnaUslugaId'] != null &&
        dodatnaUslugaResult != null) {
      List<String>? selectedUsluge = _formKey.currentState!.fields['dodatnaUslugaId']!.value?.cast<String>();
      if (selectedUsluge != null) {
        for (String uslugaId in selectedUsluge) {
          DodatnaUsluga? usluga = dodatnaUslugaResult!.result.firstWhereOrNull(
                (element) => element.dodatnaUslugaId.toString() == uslugaId,
          );
          if (usluga != null) {
            totalPrice += usluga.cijena ?? 0.0;
            _selectedDodatneUsluge.add(usluga);
          }
        }
      }
    }
    if (_selectedPeriod != null) {
      totalPrice += _selectedPeriod!.cijena ?? 0.0;
    }

    return totalPrice;
  }


  Future<void> insertRezervacija() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      var request = Map.from(_formKey.currentState!.value);
      request['korisnikId'] = ulogovaniKorisnikId;
      request['voziloId'] = widget.vozilo?.voziloId;
      request['gradId'] = int.parse(request['gradId']);

      List<int> selectedDodatnaUslugaIds = [];
      for (String uslugaId in request['dodatnaUslugaId'] ?? []) {
        selectedDodatnaUslugaIds.add(int.parse(uslugaId));
      }
      request['dodatnaUslugaId'] = selectedDodatnaUslugaIds;

      var requestJson = jsonEncode(request);

      Rezervacija rezervacija = Rezervacija.fromJson(jsonDecode(requestJson));

      await _rezervacijaProvider.insertRezervacijaWithDodatneUsluge(rezervacija);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Uspješna rezervacija'),
          content: const Text(
            'Uspješno ste rezervisali vozilo. Vaše rezervacije možete pogledati u stavci "Profil". Hvala Vam na povjerenju!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => VozilaListScreen()),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  Future<void> showConfirmationDialog(double totalPrice) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Potvrda rezervacije'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Ukupna cijena rezervacije: ${totalPrice.toStringAsFixed(2)} KM'),
                Text('Da li ste sigurni da želite potvrditi rezervaciju?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Odustani'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                insertRezervacija();
              },
              child: Text('Potvrdi'),
            ),
          ],
        );
      },
    );
  }

  List<DodatnaUsluga> _selectedDodatneUsluge = [];

  Widget _buildDodatnaUslugaDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
          child: Text(
            'Odaberite dodatne usluge ukoliko želite',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left:8.0,right:8, bottom:8),
          child: FormBuilderCheckboxGroup(
            name: "dodatnaUslugaId",
            options: dodatnaUslugaResult?.result.map((item) {
              return FormBuilderFieldOption(
                value: item.dodatnaUslugaId.toString(),
                child: Text(
                  '${item.naziv ?? ""} (${item.cijena?.toStringAsFixed(2)} KM)',
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList() ?? [],
            onChanged: (_) {
              setState(() {
                _calculateTotalPrice();
              });
            },
          ),
        ),
      ],
    );
  }





  Widget _buildGradDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FormBuilderDropdown<String>(
        name: "gradId",
        decoration: InputDecoration(
          labelText: 'Grad *',
          labelStyle: const TextStyle(color: Colors.blue),
          prefixIcon: const Icon(
            Icons.location_city,
            color: Colors.blue,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide:
                const BorderSide(color: Color.fromARGB(129, 160, 17, 7)),
          ),
          filled: true,
          fillColor: Colors.grey[200],
          hintText: 'Odaberi grad',
          hintStyle: const TextStyle(color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {
              _formKey.currentState?.fields['gradId']?.didChange(null);
            },
          ),
        ),
        items: gradResult?.result.map((item) {
              return DropdownMenuItem<String>(
                value: item.gradId.toString(),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.naziv ?? "",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            }).toList() ??
            [],
        style: const TextStyle(fontSize: 16.0),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Polje grad je obavezno';
          }
          return null;
        },
      ),
    );
  }



  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pogrešan period'),
        content: const Text('Za odabrani datum nije moguć odabrani period.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                resetSelectedDates();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: DropdownButtonFormField<CijenePoVremenskomPeriodu>(
        decoration: const InputDecoration(
          labelText: 'Period *',
          border: OutlineInputBorder(),
        ),
        value: _selectedPeriod,
        items: _cijenePoVremenskomPerioduList.map((period) {
          return DropdownMenuItem<CijenePoVremenskomPeriodu>(
            value: period,
            child: Text('${period.period?.trajanje} (${period.cijena?.toStringAsFixed(2)} KM)'),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedPeriod = newValue;
            resetSelectedDates();
            if (newValue != null) {
              _pickStartDate(context);
            }
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Polje "Period" je obavezno';
          }
          return null;
        },
      ),
    );
  }

  void resetSelectedDates() {
    setState(() {
      _selectedStartDate = null;
      _selectedEndDate = null;
      _formKey.currentState?.fields['pocetniDatum']?.didChange(null);
      _formKey.currentState?.fields['zavrsniDatum']?.didChange(null);
    });
  }

  Future<void> _pickStartDate(BuildContext context) async {
    try {
      DateTime initialDate = _selectedStartDate ?? DateTime.now();
      initialDate = _findFirstSelectableDate(initialDate);

      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
        selectableDayPredicate: (DateTime date) => isDateAvailable(date),
      );

      if (picked != null) {
        setState(() {
          _selectedStartDate = picked;
          _formKey.currentState?.fields['pocetniDatum']
              ?.didChange(DateFormat('yyyy-MM-dd').format(picked));
          _pickEndDate(context);
        });
      } else {
        resetSelectedDates();

      }
    } catch (e) {
      print('Error picking start date: $e');
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    if (_selectedPeriod == null) return;

    try {
      List<int> parts = extractNumericPart(_selectedPeriod!.period!.trajanje!);
      int minDays = parts[0] - 1;
      int maxDays = parts[1];

      DateTime startDate = _selectedStartDate!;
      DateTime initialEndDate = startDate.add(Duration(days: minDays));
      initialEndDate = _findFirstSelectableDate(initialEndDate);

      bool isAnyDateUnavailable = false;

      for (DateTime date = startDate;
          date.isBefore(initialEndDate.add(Duration(days: maxDays)));
          date = date.add(const Duration(days: 1))) {
        if (!isDateAvailable(date)) {
          isAnyDateUnavailable = true;
          break;
        }
      }

      if (isAnyDateUnavailable) {
        _showErrorDialog();
        return;
      }

      DateTime? picked = await showDatePicker(
        context: context,
        initialDate: initialEndDate,
        firstDate: initialEndDate,
        lastDate: startDate.add(Duration(days: maxDays)),
        selectableDayPredicate: (DateTime date) => isDateAvailable(date),
      );

      if (picked != null) {
        setState(() {
          _selectedEndDate = picked;
          _formKey.currentState?.fields['zavrsniDatum']
              ?.didChange(DateFormat('yyyy-MM-dd').format(picked));
        });
      } else {
        resetSelectedDates();
      }
    } catch (e) {
      print('Error picking end date: $e');
    }
  }

  DateTime _findFirstSelectableDate(DateTime start) {
    DateTime date = start;
    while (!isDateAvailable(date)) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  bool isDateAvailable(DateTime date) {
    if (rezervacijaResult != null && vozilaResult != null) {
      for (var rezervacija in rezervacijaResult!.result) {
        if (rezervacija.voziloId == widget.vozilo?.voziloId &&
            (isSameDay(rezervacija.pocetniDatum!, date) ||
                date.isAfter(rezervacija.pocetniDatum!)) &&
            (isSameDay(rezervacija.zavrsniDatum!, date) ||
                date.isBefore(rezervacija.zavrsniDatum!))) {
          return false;
        }
      }
    }
    if (voziloPregledResult != null && vozilaResult != null) {
      for (var pregled in voziloPregledResult!.result) {
        if (pregled.voziloId == widget.vozilo?.voziloId &&
            isSameDay(pregled.datum!, date)) {
          return false;
        }
      }
    }
    return true;
  }

  List<int> extractNumericPart(String input) {
    List<String> parts = input.replaceAll(' dana', '').split('-');
    int minDays = int.parse(parts[0]);
    int maxDays = int.parse(parts[1]) - 1;
    return [minDays, maxDays];
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: value,
              decoration: InputDecoration(
                labelText: label,
                border: const OutlineInputBorder(),
              ),
              readOnly: !isEditing,
              onChanged: (newValue) {},
            ),
          ),
        ],
      ),
    );
  }
}
