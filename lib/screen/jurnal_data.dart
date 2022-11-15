import 'dart:ffi';

import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/jurnal_form.dart';
import 'package:chatetan_duit/screen/jurnal_form_edit.dart';
import 'package:chatetan_duit/screen/profil_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/jurnal.dart';

class JurnalData extends StatefulWidget {
  const JurnalData({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<JurnalData> createState() => _JurnalDataState();
}

class _JurnalDataState extends State<JurnalData> {
  List<Profil> profile = [];
  List<Jurnal> jurnalData = [];
  DbProfile dbProfile = DbProfile();
  int summaryData = 0;

  @override
  void initState() {
    // TODO: implement initState
    _getProfile();
    _getJurnal();
    _getDataSummary();
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

  Future<void> _getJurnal() async {
    var list = await dbProfile.getAllJurnal();
    setState(() {
      jurnalData.clear();
      list!.forEach((jurnal) {
        jurnalData.add(Jurnal.fromMap(jurnal));
      });
    });
  }

  Future<void> _getDataSummary() async {
    var list = await dbProfile.getSummaryJurnal();
    print(list);
    setState(() {
      summaryData = list;
    });
  }

  // membuka halaman tambah Kontak
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => JurnalForm()));
    if (result == 'save') {
      await _getJurnal();
      await _getDataSummary();
    }
  }

  Future<void> _deleteJurnal(id) async {
    var delete = await dbProfile.deleteJurnal(id);
  }

  Future<void> _openFormEdit(jurnal) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return JurnalFormEdit(
            jurnal: jurnal,
          );
        },
      ),
    );
    if (result == 'edit') {
      await _getJurnal();
      await _getDataSummary();
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
              _deleteJurnal(id);
              _getJurnal();
              _getDataSummary();
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
        backgroundColor: Color.fromARGB(243, 8, 104, 77),
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
            itemCount: jurnalData.length,
            itemBuilder: (context, index) {
              Jurnal jurnal = jurnalData[index];
              return Container(
                color: Colors.white,
                margin: const EdgeInsets.only(
                  bottom: 0.5,
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.loyalty,
                    color: jurnal.tipe == 'pengeluaran'
                        ? Colors.red[900]
                        : Colors.green[700],
                    size: 30,
                  ),
                  title: Text(
                      '${jurnal.deskripsi} ${DateFormat('dd/MM/yyyy').format(DateTime.parse(jurnal.tanggal.toString()))}'),
                  subtitle: Text(
                      '${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(jurnal.jumlah)},'),
                  trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(children: [
                      IconButton(
                        onPressed: () {
                          _openFormEdit(jurnal);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteConfirm(jurnal.id);
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
