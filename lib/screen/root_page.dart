import 'package:chatetan_duit/screen/jurnal_data.dart';
import 'package:flutter/material.dart';
import 'package:chatetan_duit/screen/home_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int currentPage = 0;
  List<Widget> pages = const [
    HomePage(),
    JurnalData(title: 'Jurnal'),
    JurnalData(title: 'Jurnal'),
    JurnalData(title: 'Jurnal'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle:
                MaterialStateProperty.all(TextStyle(fontFamily: 'Roboto'))),
        child: NavigationBar(
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.book),
              label: 'Jurnal',
            ),
            NavigationDestination(
              icon: Icon(Icons.assignment),
              label: 'Anggaran',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt),
              label: 'Laporan',
            ),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              currentPage = index;
            });
            debugPrint(index.toString());
          },
          selectedIndex: currentPage,
        ),
      ),
    );
  }
}
