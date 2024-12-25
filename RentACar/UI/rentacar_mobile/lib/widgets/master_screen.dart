import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rentacar_admin/screens/cijene_po_vremenskom_periodu_screen.dart';
import 'package:rentacar_admin/screens/kontakt_screen.dart';
import 'package:rentacar_admin/screens/profil_screen.dart';
import 'package:rentacar_admin/screens/recenzije_screen.dart';
import 'package:rentacar_admin/screens/vozila_list_screen.dart';

import '../screens/to_do_4924_screen.dart';

class MasterScreenWidget extends StatefulWidget {  final NavigationController navigationController = Get.put(NavigationController());

Widget? child;
  String? title;
  Widget? title_widget;

  MasterScreenWidget({this.child, this.title, this.title_widget, super.key});

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data:  NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.all(
              const TextStyle(
                fontSize: 12.0,
                color: Colors.black,
              ),
            )),
        child: NavigationBar(
          height: 60,
          key: ValueKey(widget.navigationController.selectedIndex.value),
          elevation: 8,
          selectedIndex: widget.navigationController.selectedIndex.value,
          onDestinationSelected: (index) {
            setState(() {
              widget.navigationController.selectedIndex.value = index;
            });
            switch (index) {
              case 0:
                Get.toNamed(VozilaListScreen.routeName);
                break;
              case 1:
                Get.toNamed(CijenePoVremenskomPerioduScreen.routeName);
                break;
              case 2:
                Get.toNamed(RecenzijeScreen.routeName);
                break;
              case 3:
                Get.toNamed(KontaktScreen.routeName);
                break;
              case 4:
                Get.toNamed(ProfilScreen.routeName);
                break;
              case 5:
                Get.toNamed(ToDo4924ListScreen.routeName);
                break;

            }
          },
          backgroundColor:Colors.grey.shade200,
          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.directions_car,color: Colors.blue,),
              icon: Icon(Icons.directions_car_outlined,color: Colors.black),
              label: 'Vozila',

            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.attach_money,color: Colors.blue),
              icon: Icon(Icons.attach_money_outlined,color: Colors.black),
              label: 'Cijene',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.star,color: Colors.blue),
              icon: Icon(Icons.star_border_outlined,color: Colors.black),
              label: 'Recenzije',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.contact_phone,color: Colors.blue),
              icon: Icon(Icons.contact_phone_outlined,color: Colors.black),
              label: 'Upiti',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person,color: Colors.blue),
              icon: Icon(Icons.person_outline,color: Colors.black),
              label: 'Profil',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.work,color: Colors.blue),
              icon: Icon(Icons.work,color: Colors.black),
              label: 'ToDo4924',
            ),
          ],
        ),
      ),
      body: widget.child,
    );
  }
}
class NavigationController extends GetxController {
  var selectedIndex = 0.obs;
}
