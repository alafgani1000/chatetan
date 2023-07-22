import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/investasi.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/investasi_form_add.dart';
import 'package:chatetan_duit/screen/investasi_form_edit.dart';
import 'package:chatetan_duit/screen/pemasukan_form_edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvestasiPage extends StatefulWidget {
  const InvestasiPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<InvestasiPage> createState() => _InvestasiPageState();
}

class _InvestasiPageState extends State<InvestasiPage> {
  List<Profil> profile = [];
  List<Investasi> investasiData = [];
  DbProfile dbProfile = DbProfile();
  int summaryData = 0;

  @override
  void initState() {
    // TODO: implement initState
    _getProfile();
    _getInvestasi();
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

  Future<void> _getInvestasi() async {
    var list = await dbProfile.getInvestasi();
    setState(() {
      investasiData.clear();
      list!.forEach((investasi) {
        investasiData.add(Investasi.fromMap(investasi));
      });
    });
  }

  // membuka halaman tambah Kontak
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const InvestasiFormAdd()));
    if (result == 'save') {
      await _getInvestasi();
    }
  }

  Future<void> _deleteInvestasi(id) async {
    var delete = await dbProfile.deleteInvestasi(id);
  }

  Future<void> _openFormEdit(investasi) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InvestasiFormEdit(
            investasi: investasi,
          );
        },
      ),
    );
    if (result == 'edit') {
      await _getInvestasi();
    }
  }

  deleteConfirm(int? id) async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus data ini ?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () {
              _deleteInvestasi(id);
              _getInvestasi();
              Navigator.pop(context, 'OK');
            },
            child: const Text('Ya'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(243, 211, 233, 229),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(183, 6, 141, 150),
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: investasiData.length,
            itemBuilder: (context, index) {
              Investasi investasi = investasiData[index];
              return Container(
                padding: EdgeInsets.only(bottom: 5.0, top: 10.0),
                color: Colors.white,
                margin: const EdgeInsets.only(
                  bottom: 0.5,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.8),
                  child: ListTile(
                    leading: Icon(
                      Icons.wallet,
                      color: Color.fromARGB(255, 15, 190, 196),
                      size: 30,
                    ),
                    title: Text('${investasi.platfom}'),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Text('Periode bagi per ${investasi.periodebagi}'),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                            '${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(investasi.jumlah)},'),
                      ],
                    ),
                    trailing: FittedBox(
                      fit: BoxFit.fill,
                      child: Row(children: [
                        IconButton(
                          onPressed: () {
                            _openFormEdit(investasi);
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            deleteConfirm(investasi.id);
                          },
                          icon: Icon(Icons.delete),
                        )
                      ]),
                    ),
                  ),
                ),
              );
            },
          ),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
