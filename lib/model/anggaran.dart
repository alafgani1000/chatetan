class Anggaran {
  int? id;
  int? bulan;
  int? tahun;
  int? jumlah;
  String? tanggal;
  int? jumlahpakai;

  Anggaran({
    this.id,
    this.bulan,
    this.tahun,
    this.jumlah,
    this.tanggal,
    this.jumlahpakai,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['bulan'] = bulan;
    map['tahun'] = tahun;
    map['jumlah'] = jumlah;
    map['tanggal'] = tanggal;
    map['jumlahpakai'] = jumlahpakai;
    return map;
  }

  Anggaran.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.bulan = map['bulan'];
    this.tahun = map['tahun'];
    this.jumlah = map['jumlah'];
    this.tanggal = map['tanggal'];
    this.jumlahpakai = map['jumlahpakai'];
  }
}
