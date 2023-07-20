class Investasi {
  int? id;
  String? platfom;
  int? jumlah;
  String? periodebagi;
  String? deskripsi;
  String? tanggal;

  Investasi({
    this.id,
    this.platfom,
    this.jumlah,
    this.periodebagi,
    this.deskripsi,
    this.tanggal,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['platfom'] = platfom;
    map['jumlah'] = jumlah;
    map['periodebagi'] = periodebagi;
    map['deskripsi'] = deskripsi;
    map['tanggal'] = tanggal;
    return map;
  }

  Investasi.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.platfom = map['platfom'];
    this.jumlah = map['jumlah'];
    this.periodebagi = map['periodebagi'];
    this.deskripsi = map['deskripsi'];
    this.tanggal = map['tanggal'];
  }
}
