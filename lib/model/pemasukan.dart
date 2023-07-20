class Pemasukan {
  int? id;
  int? jumlah;
  String? deskripsi;
  String? tanggal;

  Pemasukan({
    this.id,
    this.jumlah,
    this.deskripsi,
    this.tanggal,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['jumlah'] = jumlah;
    map['deskripsi'] = deskripsi;
    map['tanggal'] = tanggal;
    return map;
  }

  Pemasukan.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.jumlah = map['jumlah'];
    this.deskripsi = map['deskripsi'];
    this.tanggal = map['tanggal'];
  }
}
