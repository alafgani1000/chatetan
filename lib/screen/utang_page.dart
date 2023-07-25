import 'dart:ffi';

import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/profil.dart';
import 'package:chatetan_duit/model/utang.dart';
import 'package:chatetan_duit/screen/pemasukan_form_edit.dart';
import 'package:chatetan_duit/screen/utang_form_add.dart';
import 'package:chatetan_duit/screen/utang_form_edit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UtangPage extends StatefulWidget {
  const UtangPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<UtangPage> createState() => _UtangPageState();
}

class _UtangPageState extends State<UtangPage> {
  List<Profil> profile = [];
  List<Utang> utangData = [];
  DbProfile dbProfile = DbProfile();
  int summaryData = 0;

  @override
  void initState() {
    // TODO: implement initState
    _getProfile();
    _getUtang();
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

  Future<void> _getUtang() async {
    var list = await dbProfile.getUtang();
    setState(() {
      utangData.clear();
      list!.forEach((utang) {
        utangData.add(Utang.fromMap(utang));
      });
    });
  }

  Future<void> _getTotal() async {
    var list = await dbProfile.getTotalUtang();
    setState(() {
      summaryData = list;
    });
  }

  // membuka halaman tambah Kontak
  Future<void> _openFormCreate() async {
    var result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const UtangFormAdd()));
    if (result == 'save') {
      await _getUtang();
      await _getTotal();
    }
  }

  Future<void> _deleteUtang(id) async {
    var delete = await dbProfile.deleteUtang(id);
  }

  Future<void> _openFormEdit(utang) async {
    var result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return UtangFormEdit(
            utang: utang,
          );
        },
      ),
    );
    if (result == 'edit') {
      await _getUtang();
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
              _deleteUtang(id);
              _getUtang();
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
            itemCount: utangData.length,
            itemBuilder: (context, index) {
              Utang utang = utangData[index];
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
                      '${utang.deskripsi} ${DateFormat('dd/MM/yyyy').format(DateTime.parse(utang.jatuhtempo.toString()))}'),
                  subtitle: Text(
                      '${NumberFormat.currency(locale: 'id', symbol: 'Rp ', decimalDigits: 2).format(utang.jumlah)},'),
                  trailing: FittedBox(
                    fit: BoxFit.fill,
                    child: Row(children: [
                      IconButton(
                        onPressed: () {
                          _openFormEdit(utang);
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteConfirm(utang.id);
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
