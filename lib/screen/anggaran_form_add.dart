import 'package:chatetan_duit/model/anggaran.dart';
import 'package:flutter/material.dart';

class AnggaranFormAdd extends StatefulWidget {
  const AnggaranFormAdd({Key? key, this.anggaran}) : super(key: key);
  final Anggaran? anggaran;

  @override
  State<AnggaranFormAdd> createState() => _AnggaranFormAddState();
}

class _AnggaranFormAddState extends State<AnggaranFormAdd> {
  TextEditingController? jumlah;

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
    print(bulan);
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
                keyboardType: TextInputType.numberWithOptions(),
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
