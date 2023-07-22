import 'package:chatetan_duit/model/investasi.dart';
import 'package:chatetan_duit/model/pemasukan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../database/db_profile.dart';
import '../model/jurnal.dart';

class InvestasiFormEdit extends StatefulWidget {
  const InvestasiFormEdit({Key? key, this.investasi}) : super(key: key);
  final Investasi? investasi;

  @override
  State<InvestasiFormEdit> createState() => _InvestasiFormEditState();
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

class _InvestasiFormEditState extends State<InvestasiFormEdit> {
  DbProfile dbProfile = DbProfile();

  TextEditingController? deskripsi;
  TextEditingController? jumlah;
  TextEditingController? tanggal;
  TextEditingController? platfom;
  TextEditingController? periodebagi;

  @override
  void initState() {
    // TODO: implement initState
    final formater = NumberFormat.currency(symbol: "", locale: "id");
    double jumlahEdit = double.parse(widget.investasi!.jumlah.toString());
    deskripsi = TextEditingController(
        text: widget.investasi == null ? '' : widget.investasi!.deskripsi);
    jumlah = TextEditingController(
        text: widget.investasi == null ? '' : formater.format(jumlahEdit));
    tanggal = TextEditingController(
        text: widget.investasi == null ? '' : widget.investasi!.tanggal);
    platfom = TextEditingController(
        text: widget.investasi == null ? '' : widget.investasi!.platfom);
    periodebagi = TextEditingController(
        text: widget.investasi == null ? '' : widget.investasi!.periodebagi);
    super.initState();
  }

  Future<void> upsertInvestasi() async {
    List<String> jumlahList = jumlah!.text.toString().split(",");
    String jumlahString = jumlahList[0].toString().replaceAll(".", "");
    await dbProfile.updateInvestasi(
      Investasi(
        platfom: platfom!.text,
        periodebagi: periodebagi!.text,
        deskripsi: deskripsi!.text,
        jumlah: int.parse(jumlahString),
        tanggal: tanggal!.text,
        id: widget.investasi!.id,
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
        title: Text('Edit Investasi'),
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
                    return 'Platfom harus di isi';
                  }
                  return null;
                },
                controller: platfom,
                decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 78, 73, 73),
                    ),
                    labelText: 'Platfom',
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
                    return 'Periode bagi harus di isi';
                  }
                  return null;
                },
                controller: periodebagi,
                decoration: InputDecoration(
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 78, 73, 73),
                    ),
                    labelText: 'Periode Bagi',
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
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(
                            primary: Color.fromARGB(
                                255, 10, 175, 134), // header background color
                            onPrimary: Color.fromARGB(
                                255, 251, 250, 250), // header text color
                            onSurface:
                                Color.fromARGB(255, 8, 8, 8), // body text color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              primary: Color.fromARGB(
                                  255, 21, 5, 4), // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
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
                    upsertInvestasi();
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
