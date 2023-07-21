import 'package:chatetan_duit/database/db_profile.dart';
import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/pengeluaran.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PengeluaranFormAdd extends StatefulWidget {
  const PengeluaranFormAdd({Key? key, this.pengeluaran, this.anggaran})
      : super(key: key);
  final Pengeluaran? pengeluaran;
  final Anggaran? anggaran;

  @override
  State<PengeluaranFormAdd> createState() => _PengeluaranFormAddState();
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

class _PengeluaranFormAddState extends State<PengeluaranFormAdd> {
  DbProfile dbProfile = DbProfile();

  TextEditingController? deskripsi;
  TextEditingController? jumlah;
  TextEditingController? tanggal;
  String jumlahCurrency = '';

  @override
  void initState() {
    // TODO: implement initState
    deskripsi = TextEditingController(
        text: widget.pengeluaran == null ? '' : widget.pengeluaran!.deskripsi);
    jumlah = TextEditingController(
        text: widget.pengeluaran == null
            ? ''
            : widget.pengeluaran!.jumlah.toString());
    tanggal = TextEditingController(
        text: widget.pengeluaran == null ? '' : widget.pengeluaran!.tanggal);
    super.initState();
  }

  Future<void> upsertPengeluaran() async {
    List<String> jumlahList = jumlah!.text.toString().split(",");
    String jumlahString = jumlahList[0].toString().replaceAll(".", "");
    int newJp = int.parse(widget.anggaran!.jumlahpakai.toString()) +
        int.parse(jumlahString);
    var input = await dbProfile.savePengeluaran(
      Pengeluaran(
        deskripsi: deskripsi!.text,
        jumlah: int.parse(jumlahString),
        tanggal: tanggal!.text,
        anggaranid: widget.anggaran!.id,
      ),
    );
    await dbProfile.updateAnggaran(
      Anggaran(
        bulan: widget.anggaran!.bulan,
        tahun: widget.anggaran!.tahun,
        jumlah: widget.anggaran!.jumlah,
        jumlahpakai: newJp,
        id: widget.anggaran!.id,
      ),
    );
    Navigator.pop(context, 'save');
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(183, 6, 141, 150),
        title: Text('Input Pengeluaran'),
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
                onChanged: (String value) async {
                  setState(() {
                    jumlahCurrency = value;
                  });
                },
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
                    String formatDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
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
                  primary: Color.fromARGB(243, 13, 152, 159),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    upsertPengeluaran();
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
