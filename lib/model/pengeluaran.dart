class Pengeluaran {
  int? id;
  int? jumlah;
  String? deskripsi;
  String? tanggal;
  int? anggaranid;

  Pengeluaran({
    this.id,
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
    map['jumlah'] = jumlah;
    map['deskripsi'] = deskripsi;
    map['tanggal'] = tanggal;
    map['anggaranid'] = anggaranid;
    return map;
  }

  Pengeluaran.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.jumlah = map['jumlah'];
    this.deskripsi = map['deskripsi'];
    this.tanggal = map['tanggal'];
    this.anggaranid = map['anggaranid'];
  }
}
