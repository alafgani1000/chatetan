import 'package:chatetan_duit/model/pemasukan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../database/db_profile.dart';
import '../model/jurnal.dart';

class PemasukanFormEdit extends StatefulWidget {
  const PemasukanFormEdit({Key? key, this.pemasukan}) : super(key: key);
  final Pemasukan? pemasukan;

  @override
  State<PemasukanFormEdit> createState() => _PemasukanFormEditState();
}

class CurrencyPtBrInputFormatter extends TextInputFormatter {
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    double value = double.parse(newValue.text);
    final formatter = NumberFormat.currency(
      locale: 'id',
      symbol: '',
    );
    String newText = formatter.format(value / 100);

    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }
}

class _PemasukanFormEditState extends State<PemasukanFormEdit> {
  DbProfile dbProfile = DbProfile();

  TextEditingController? deskripsi;
  TextEditingController? jumlah;
  TextEditingController? tanggal;

  @override
  void initState() {
    // TODO: implement initState
    final formater = NumberFormat.currency(symbol: "", locale: "id");
    double jumlahEdit = double.parse(widget.pemasukan!.jumlah.toString());
    deskripsi = TextEditingController(
        text: widget.pemasukan == null ? '' : widget.pemasukan!.deskripsi);
    jumlah = TextEditingController(
        text: widget.pemasukan == null ? '' : formater.format(jumlahEdit));
    tanggal = TextEditingController(
        text: widget.pemasukan == null ? '' : widget.pemasukan!.tanggal);
    super.initState();
  }

  Future<void> upsertPemasukan() async {
    List<String> jumlahList = jumlah!.text.toString().split(",");
    String jumlahString = jumlahList[0].toString().replaceAll(".", "");
    await dbProfile.updatePemasukan(
      Pemasukan(
        deskripsi: deskripsi!.text,
        jumlah: int.parse(jumlahString),
        tanggal: tanggal!.text,
        id: widget.pemasukan!.id,
      ),
    );
    Navigator.pop(context, 'edit');
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(183, 6, 141, 150),
        title: Text('Edit Pemasukan'),
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
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyPtBrInputFormatter(),
                ],
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(183, 6, 141, 150),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    upsertPemasukan();
                  }
                },
                child: const Text(
                  'Ubah',
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
