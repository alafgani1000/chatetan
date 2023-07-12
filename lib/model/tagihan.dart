class Tagihan {
  int? id;
  String? deskripsi;
  int? peringatan;
  int? jumlah;
  String? tanggal;

  Tagihan({
    this.id,
    this.deskripsi,
    this.peringatan,
    this.jumlah,
    this.tanggal,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['deskripsi'] = deskripsi;
    map['peringatan'] = peringatan;
    map['jumlah'] = jumlah;
    map['tanggal'] = tanggal;
    return map;
  }

  Tagihan.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.deskripsi = map['deskripsi'];
    this.peringatan = map['peringatan'];
    this.jumlah = map['jumlah'];
    this.tanggal = map['tanggal'];
  }
}
