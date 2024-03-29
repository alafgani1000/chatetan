import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

import '../database/db_profile.dart';
import '../model/jurnal.dart';

enum tipePilihan { pemasukan, pengeluaran }

class JurnalFormEdit extends StatefulWidget {
  const JurnalFormEdit({Key? key, this.jurnal}) : super(key: key);
  final Jurnal? jurnal;

  @override
  State<JurnalFormEdit> createState() => _JurnalFormEditState();
}

class _JurnalFormEditState extends State<JurnalFormEdit> {
  DbProfile dbProfile = DbProfile();
  tipePilihan? _tipe = tipePilihan.pemasukan;

  TextEditingController? deskripsi;
  TextEditingController? jumlah;
  TextEditingController? tanggal;

  @override
  void initState() {
    // TODO: implement initState
    deskripsi = TextEditingController(
        text: widget.jurnal == null ? '' : widget.jurnal!.deskripsi);
    jumlah = TextEditingController(
        text: widget.jurnal == null ? '' : widget.jurnal!.jumlah.toString());
    tanggal = TextEditingController(
        text: widget.jurnal == null ? '' : widget.jurnal!.tanggal);
    widget.jurnal!.tipe == 'pemasukan'
        ? _tipe = tipePilihan.pemasukan
        : _tipe = tipePilihan.pengeluaran;
    super.initState();
  }

  Future<void> upsertJurnal() async {
    String tipeData = '';
    if (_tipe == tipePilihan.pemasukan) {
      tipeData = 'pemasukan';
    } else {
      tipeData = 'pengeluaran';
    }
    await dbProfile.updateJurnal(
      Jurnal(
        deskripsi: deskripsi!.text,
        jumlah: int.parse(jumlah!.text),
        tanggal: tanggal!.text,
        tipe: tipeData,
        id: widget.jurnal!.id,
      ),
    );
    Navigator.pop(context, 'edit');
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(243, 8, 104, 77),
        title: Text('Catet'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskrispsi harus di isi';
                  }
                  return null;
                },
                controller: deskripsi,
                decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 78, 73, 73),
                    ),
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: Color.fromARGB(243, 124, 109, 123),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Color.fromARGB(243, 124, 109, 123),
                    ))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah harus di isi';
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
                keyboardType: TextInputType.numberWithOptions(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal harus di isi';
                  }
                  return null;
                },
                controller: tanggal,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  label: Text('Tanggal'),
                  labelStyle: TextStyle(
                    color: Color.fromARGB(255, 78, 73, 73),
                  ),
                  // icon: const Icon(
                  //   Icons.calendar_month,
                  //   color: Colors.black,
                  //   size: 40,
                  // ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(243, 124, 109, 123),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(243, 124, 109, 123),
                    ),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(200),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    print(pickedDate);
                    String formatDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(formatDate);
                    setState(() {
                      tanggal?.text = formatDate;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Pemasukan'),
              leading: Radio<tipePilihan>(
                value: tipePilihan.pemasukan,
                groupValue: _tipe,
                onChanged: (tipePilihan? value) {
                  setState(() {
                    _tipe = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Pengeluaran'),
              leading: Radio<tipePilihan>(
                value: tipePilihan.pengeluaran,
                groupValue: _tipe,
                onChanged: (tipePilihan? value) {
                  setState(() {
                    _tipe = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(183, 2, 101, 65),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  upsertJurnal();
                }
              },
              child: const Text(
                'Ubah',
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
