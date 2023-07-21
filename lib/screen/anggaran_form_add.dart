import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/jurnal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AnggaranFormAdd extends StatefulWidget {
  const AnggaranFormAdd({Key? key, this.anggaran}) : super(key: key);
  final Anggaran? anggaran;

  @override
  State<AnggaranFormAdd> createState() => _AnggaranFormAddState();
}

class _AnggaranFormAddState extends State<AnggaranFormAdd> {
  DbProfile dbProfile = DbProfile();
  TextEditingController? jumlah;
  String anggaranCheck = '';

  @override
  void initState() {
    jumlah = TextEditingController(
        text:
            widget.anggaran == null ? '' : widget.anggaran!.jumlah.toString());

    super.initState();
  }

  Future<void> insertAnggaran() async {
    var currDate = DateTime.now();
    int tahun = currDate.year;
    int bulan = currDate.month;
    String date = DateFormat('yyyy-MM-dd').format(currDate);
    var check = await dbProfile.getCurrAnggJumlah();
    if (check == null) {
      await dbProfile.saveAnggaran(
        Anggaran(
            bulan: bulan,
            tahun: tahun,
            jumlah: int.parse(jumlah!.text),
            tanggal: date,
            jumlahpakai: 0),
      );
      Navigator.pop(context, 'save');
    } else {
      setState(() {
        anggaranCheck = 'Anggaran bulan ini sudah di input';
      });
    }
  }

  final _formkey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(183, 6, 141, 150),
        title: Text('Input Anggaran Bulanan'),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
                bottom: 8,
              ),
              child: Text(
                anggaranCheck,
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jumlah anggaran harus di isi";
                  }
                  return null;
                },
                controller: jumlah,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 78, 73, 73),
                  ),
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(243, 124, 109, 123),
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(243, 124, 109, 123),
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(183, 8, 182, 188),
                    minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    insertAnggaran();
                  }
                },
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
