import 'package:chatetan_duit/screen/anggaran_page.dart';
import 'package:chatetan_duit/screen/jurnal_data.dart';
import 'package:chatetan_duit/screen/pemasukan_page.dart';
import 'package:chatetan_duit/screen/pengeluaran_page.dart';
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
    PemasukanPage(title: 'Pemasukan'),
    PengeluaranPage(title: 'Pengeluaran'),
    AnggaranPage(title: 'Anggaran'),
    JurnalData(title: 'Jurnal'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                fontFamily: 'Roboto',
                fontSize: 11.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white),
        child: NavigationBar(
          backgroundColor: Colors.white,
          height: 60,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home,
                size: 20,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.book,
                size: 20,
              ),
              label: 'Pemasukan',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.app_shortcut,
                size: 20,
              ),
              label: 'Pengeluaran',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.assignment,
                size: 20,
              ),
              label: 'Anggaran',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.receipt,
                size: 20,
              ),
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
