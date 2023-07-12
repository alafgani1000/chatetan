import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/profil.dart';
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

  Widget build(BuildContext context) {
    return Container();
  }
}
