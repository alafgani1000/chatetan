import 'dart:ffi';

import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/pengeluaran.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/screen/jurnal_form_edit.dart';
import 'package:chatetan_duit/screen/pengeluaran_form_add.dart';
import 'package:chatetan_duit/screen/pengeluaran_form_edit.dart';
import 'package:chatetan_duit/screen/profil_form.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  List<Profil> profile = [];
  List<Pengeluaran> PengeluaranData = [];
  List<Anggaran> anggaranData = [];
  DbProfile dbProfile = DbProfile();
  int summaryData = 0;

  @override
  void initState() {
    // TODO: implement initState
    _getProfile();
    _getPengeluaran();
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

  Future<void> _getPengeluaran() async {
    var idAnggaran = await dbProfile.getIdAnggaran();
    if (idAnggaran != null) {
      var list = await dbProfile.getPengeluaranPerbulan(idAnggaran);
      setState(() {
        PengeluaranData.clear();
        list!.forEach((pengeluaran) {
          PengeluaranData.add(Pengeluaran.fromMap(pengeluaran));
        });
      });
    }
  }

  Future<void> _getDataSummary() async {
    var idAnggaran = await dbProfile.getIdAnggaran();
    if (idAnggaran != null) {
      var list = await dbProfile.getTotalPengeluaranPerbulan(idAnggaran);
      setState(() {
        summaryData = list;
      });
    }
  }

  // membuka halaman tambah Kontak
  Future<void> _openFormCreate() async {
    var list = await dbProfile.getAnggaran();
    setState(() {
      anggaranData.clear();
      list!.forEach((anggaran) {
        anggaranData.add(Anggaran.fromMap(anggaran));
      });
    });
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PengeluaranFormAdd(
                  anggaran: anggaranData[0],
                )));
    if (result == 'save') {
      await _getPengeluaran();
      await _getDataSummary();
    }
  }

  Future<void> _deletePengeluaran(id) async {
    var delete = await dbProfile.deleteJurnal(id);
  }

  Future<void> _openFormEdit(pengeluaran) async {
    var list = await dbProfile.getAnggaran();
    setState(() {
      anggaranData.clear();
      list!.forEach((anggaran) {
        anggaranData.add(Anggaran.fromMap(anggaran));
      });
    });
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return PengeluaranFormEdit(
            anggaran: anggaranData[0],
            pengeluaran: pengeluaran,
          );
        },
      ),
    );
    if (result == 'edit') {
      await _getPengeluaran();
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
              _deletePengeluaran(id);
              _getPengeluaran();
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
        backgroundColor: const Color.fromARGB(183, 6, 141, 150),
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom: BorderSide(
                        color: Color.fromARGB(183, 7, 126, 142), width: 1.0))),
            child: Text(
              'Saldo: ${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(summaryData)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: PengeluaranData.length,
            itemBuilder: (context, index) {
              Pengeluaran pengeluaran = PengeluaranData[index];
              return Container(
                color: Colors.white,
                margin: const EdgeInsets.only(
                  bottom: 0.5,
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.loyalty,
                    color: Color.fromARGB(255, 214, 39, 57),
                    size: 30,
                  ),
                  title: Text(
                      '${pengeluaran.deskripsi} ${DateFormat('dd/MM/yyyy').format(DateTime.parse(pengeluaran.tanggal.toString()))}'),
                  subtitle: Text(
                      '${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(pengeluaran.jumlah)},'),
                  trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(children: [
                      IconButton(
                        onPressed: () {
                          _openFormEdit(pengeluaran);
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteConfirm(pengeluaran.id);
                        },
                        icon: const Icon(Icons.delete),
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
