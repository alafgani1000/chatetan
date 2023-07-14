import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/anggaran_form_add.dart';
import 'package:flutter/material.dart';

class AnggaranPage extends StatefulWidget {
  const AnggaranPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AnggaranPage> createState() => _AnggaranPageState();
}

class _AnggaranPageState extends State<AnggaranPage> {
  List<Profil> profile = [];
  List<Anggaran> anaggaran = [];
  DbProfile dbProfile = DbProfile();
  int jumlah = 0;
  int jumlahp = 0;

  @override
  void initState() {
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

  Future<void> _getAnggaran() async {
    var curJumlah = await dbProfile.getCurrAnggJumlah();
    var curJumlahp = await dbProfile.getCurrAnggJump();
    setState(() {
      jumlah = curJumlah;
      jumlahp = curJumlahp;
    });
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
        children: [],
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
