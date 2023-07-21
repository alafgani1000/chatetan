import 'dart:ffi';

import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/pemasukan.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/jurnal_form.dart';
import 'package:chatetan_duit/screen/jurnal_form_edit.dart';
import 'package:chatetan_duit/screen/pemasukan_form_add.dart';
import 'package:chatetan_duit/screen/pemasukan_form_edit.dart';
import 'package:chatetan_duit/screen/profil_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/jurnal.dart';

class PemasukanPage extends StatefulWidget {
  const PemasukanPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PemasukanPage> createState() => _PemasukanPageState();
}

class _PemasukanPageState extends State<PemasukanPage> {
  List<Profil> profile = [];
  List<Pemasukan> pemasukanData = [];
  DbProfile dbProfile = DbProfile();
  int summaryData = 0;

  @override
  void initState() {
    // TODO: implement initState
    _getProfile();
    _getPemasukan();
    _getTotal();
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

  Future<void> _getPemasukan() async {
    var list = await dbProfile.getPemasukan();
    setState(() {
      pemasukanData.clear();
      list!.forEach((pemasukan) {
        pemasukanData.add(Pemasukan.fromMap(pemasukan));
      });
    });
  }

  Future<void> _getTotal() async {
    var list = await dbProfile.getTotalPemasukan();
    setState(() {
      summaryData = list;
    });
  }

  // membuka halaman tambah Kontak
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const PemasukanFormAdd()));
    if (result == 'save') {
      await _getPemasukan();
      await _getTotal();
    }
  }

  Future<void> _deletePemasukan(id) async {
    var delete = await dbProfile.deletePemasukan(id);
  }

  Future<void> _openFormEdit(jurnal) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PemasukanFormEdit(
            pemasukan: jurnal,
          );
        },
      ),
    );
    if (result == 'edit') {
      await _getPemasukan();
      await _getTotal();
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
              _deletePemasukan(id);
              _getPemasukan();
              _getTotal();
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
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(183, 7, 126, 142), width: 1.0))),
            child: Text(
              'Saldo: ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(summaryData)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: pemasukanData.length,
            itemBuilder: (context, index) {
              Pemasukan pemasukan = pemasukanData[index];
              return Container(
                color: Colors.white,
                margin: const EdgeInsets.only(
                  bottom: 0.5,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.loyalty,
                    color: Colors.green[700],
                    size: 30,
                  ),
                  title: Text(
                      '${pemasukan.deskripsi} ${DateFormat('dd/MM/yyyy').format(DateTime.parse(pemasukan.tanggal.toString()))}'),
                  subtitle: Text(
                      '${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(pemasukan.jumlah)},'),
                  trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(children: [
                      IconButton(
                        onPressed: () {
                          _openFormEdit(pemasukan);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteConfirm(pemasukan.id);
                        },
                        icon: Icon(Icons.delete),
                      )
                    ]),
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
