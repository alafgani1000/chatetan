class Jurnal {
  int? id;
  String? tipe;
  int? jumlah;
  String? deskripsi;
  String? tanggal;
  int? anggaranid;

  Jurnal({
    this.id,
    this.tipe,
    this.jumlah,
    this.deskripsi,
    this.tanggal,
    this.anggaranid,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['tipe'] = tipe;
    map['jumlah'] = jumlah;
    map['deskripsi'] = deskripsi;
    map['tanggal'] = tanggal;
    map['anggaranid'] = anggaranid;
    return map;
  }

  Jurnal.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.tipe = map['tipe'];
    this.jumlah = map['jumlah'];
    this.deskripsi = map['deskripsi'];
    this.tanggal = map['tanggal'];
    this.anggaranid = map['anggaranid'];
  }
}
