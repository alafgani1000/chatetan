import 'package:chatetan_duit/screen/anggaran_page.dart';
import 'package:chatetan_duit/screen/investasi_page.dart';
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
    // InvestasiPage(title: 'Investasi'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white),
        child: NavigationBar(
          backgroundColor: Colors.white,
          height: 65,
          destinations: const [
            NavigationDestination(
              icon: Icon(
                Icons.home,
                size: 25,
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.book,
                size: 25,
              ),
              label: 'Pemasukan',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.app_shortcut,
                size: 25,
              ),
              label: 'Pengeluaran',
            ),
            NavigationDestination(
              icon: Icon(
                Icons.assignment,
                size: 25,
              ),
              label: 'Anggaran',
            ),
            // NavigationDestination(
            //   icon: Icon(
            //     Icons.currency_exchange,
            //     size: 20,
            //   ),
            //   label: 'Investasi',
            // ),
          ],
          onDestinationSelected: (int index) {
            setState(() {
              currentPage = index;
            });
          },
          selectedIndex: currentPage,
        ),
      ),
    );
  }
}
