import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rentacar_admin/models/rezervacija.dart';
import 'package:rentacar_admin/models/vozila.dart';
import 'package:rentacar_admin/models/gorivo.dart';
import 'package:rentacar_admin/models/tip_vozila.dart';
import 'package:rentacar_admin/providers/gorivo_provider.dart';
import 'package:rentacar_admin/providers/tip_vozila_provider.dart';
import 'package:rentacar_admin/providers/vozila_provider.dart';
import 'package:rentacar_admin/screens/vozila_detail_screen.dart';

class RecommendedReservationsWidget extends StatelessWidget {
  final List<Rezervacija> recommendedReservations;
  final VozilaProvider _vozilaProvider = VozilaProvider();
  final GorivoProvider _gorivoProvider = GorivoProvider();
  final TipVozilaProvider _tipVozilaProvider = TipVozilaProvider();

  RecommendedReservationsWidget({required this.recommendedReservations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preporučene rezervacije za vozilo:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: recommendedReservations.map((reservation) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<Vozilo?>(
                  future: _loadVoziloData(reservation.voziloId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      Vozilo? vozilo = snapshot.data;
                      if (vozilo != null) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          width: 300,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 160,
                                width: 280,
                                child: Image.memory(
                                  base64Decode(vozilo.slika!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 10),
                              ListTile(
                                title: Text('${vozilo.model}, ${vozilo.marka}', style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoTile('Godina proizvodnje', '${vozilo.godinaProizvodnje}'),
                                    _buildInfoTile('Kilometraža', '${vozilo.kilometraza} km'),
                                    _buildInfoTile('Gorivo', '${vozilo.gorivo?.tip ?? 'N/A'}'),
                                    _buildInfoTile('Tip vozila', '${vozilo.tipVozila?.tip ?? 'N/A'}'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VozilaDetailScreen(vozilo: vozilo),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color(0xFF480707),
                                  side: BorderSide(color: Colors.white, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Detalji vozila',
                                  style: TextStyle(color: Colors.white),
                                ),
                              )

                            ],
                          ),
                        );
                      } else {
                        return Text('Vozilo nije pronađeno');
                      }
                    }
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Future<Vozilo?> _loadVoziloData(int voziloId) async {
    Vozilo? vozilo = await _vozilaProvider.getByVoziloId(voziloId);
    if (vozilo != null) {
      if (vozilo.gorivoId != null) {
        vozilo.gorivo = await _gorivoProvider.getById(vozilo.gorivoId!);
      }
      if (vozilo.tipVozilaId != null) {
        vozilo.tipVozila = await _tipVozilaProvider.getById(vozilo.tipVozilaId!);
      }
    }
    return vozilo;
  }

  Widget _buildInfoTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}
