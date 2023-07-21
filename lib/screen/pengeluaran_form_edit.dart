import 'package:chatetan_duit/model/anggaran.dart';
import 'package:chatetan_duit/model/pemasukan.dart';
import 'package:chatetan_duit/model/pengeluaran.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../database/db_profile.dart';

class PengeluaranFormEdit extends StatefulWidget {
  const PengeluaranFormEdit({Key? key, this.pengeluaran, this.anggaran})
      : super(key: key);
  final Anggaran? anggaran;
  final Pengeluaran? pengeluaran;

  @override
  State<PengeluaranFormEdit> createState() => _PengeluaranFormEditState();
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

class _PengeluaranFormEditState extends State<PengeluaranFormEdit> {
  DbProfile dbProfile = DbProfile();

  TextEditingController? deskripsi;
  TextEditingController? jumlah;
  TextEditingController? tanggal;
  TextEditingController? anggaranid;
  int oldJumlah = 0;

  @override
  void initState() {
    // TODO: implement initState
    final formater = NumberFormat.currency(symbol: "", locale: "id");
    double jumlahEdit = double.parse(widget.pengeluaran!.jumlah.toString());
    deskripsi = TextEditingController(
        text: widget.pengeluaran == null ? '' : widget.pengeluaran!.deskripsi);
    jumlah = TextEditingController(
        text: widget.pengeluaran == null ? '' : formater.format(jumlahEdit));
    tanggal = TextEditingController(
        text: widget.pengeluaran == null ? '' : widget.pengeluaran!.tanggal);
    anggaranid = TextEditingController(
        text: widget.pengeluaran == null
            ? ''
            : widget.pengeluaran!.anggaranid.toString());
    oldJumlah = int.parse(widget.pengeluaran!.jumlah.toString());
    super.initState();
  }

  Future<void> upsertPengeluaran() async {
    List<String> jumlahList = jumlah!.text.toString().split(",");
    String jumlahString = jumlahList[0].toString().replaceAll(".", "");
    var update = await dbProfile.updatePengeluaran(Pengeluaran(
      deskripsi: deskripsi!.text,
      jumlah: int.parse(jumlahString),
      tanggal: tanggal!.text,
      anggaranid: widget.pengeluaran!.anggaranid,
      id: widget.pengeluaran!.id,
    ));
    await dbProfile.updateAnggaran(
      Anggaran(
        bulan: widget.anggaran!.bulan,
        tahun: widget.anggaran!.tahun,
        jumlah: widget.anggaran!.jumlah,
        jumlahpakai:
            (int.parse(widget.anggaran!.jumlahpakai.toString()) - oldJumlah) +
                int.parse(jumlahString),
        tanggal: widget.anggaran!.tanggal,
        id: widget.anggaran!.id,
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
        title: Text('Edit Pengeluaran'),
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
                    upsertPengeluaran();
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
