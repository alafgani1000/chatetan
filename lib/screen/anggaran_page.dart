import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/anggaran_form_add.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnggaranPage extends StatefulWidget {
  const AnggaranPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AnggaranPage> createState() => _AnggaranPageState();
}

class _AnggaranPageState extends State<AnggaranPage> {
  List<Profil> profile = [];
  List<Anggaran> anggaranData = [];
  DbProfile dbProfile = DbProfile();
  int jumlah = 0;
  int jumlahp = 0;

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  @override
  void initState() {
    _getAnggaran();
    super.initState();
  }

  Future<void> _getProfile() async {
    var list = await dbProfile.getProfile();
    setState(() {
      profile.clear();
      list!.forEach((profil) {
        profile.add(Profil.fromMap(profil));
      });
    });
  }

  Future<void> get_a() async {
    var curJumlah = await dbProfile.getCurrAnggJumlah();
    var curJumlahp = await dbProfile.getCurrAnggJump();
    setState(() {
      jumlah = curJumlah;
      jumlahp = curJumlahp;
    });
  }

  Future<void> _getAnggaran() async {
    var list = await dbProfile.getAnggaran();
    setState(() {
      anggaranData.clear();
      list!.forEach((anggaran) {
        anggaranData.add(Anggaran.fromMap(anggaran));
      });
    });
    print('test');
  }

  // membuka halaman tambah Kontak
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AnggaranFormAdd()));
    if (result == 'save') {}
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(243, 211, 233, 229),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(183, 6, 141, 150),
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 1,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: anggaranData.length,
            itemBuilder: (context, index) {
              Anggaran anggaran = anggaranData[index];
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.account_balance_wallet,
                    color: Color.fromARGB(255, 176, 189, 179),
                    size: 40,
                  ),
                  title: Text(
                    'Anggaran bulan ${months.elementAt(anggaran.bulan! - 1)}',
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Anggaran',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 2,
                        ).format(anggaran.jumlah),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Pengeluaran',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 2,
                        ).format(anggaran.jumlahpakai),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Text(
                        'Sisa',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        NumberFormat.currency(
                          locale: 'id',
                          symbol: 'Rp ',
                          decimalDigits: 2,
                        ).format(anggaran.jumlah! - anggaran.jumlahpakai!),
                      )
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _openFormCreate();
        },
        tooltip: 'Add',
        child: const Icon(
          Icons.add,
          size: 20,
        ),
      ),
    );
  }
}
