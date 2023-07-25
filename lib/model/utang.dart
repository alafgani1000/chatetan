class Utang {
  int? id;
  String? deskripsi;
  int? jumlah;
  String? jatuhtempo;

  Utang({
    this.id,
    this.deskripsi,
    this.jumlah,
    this.jatuhtempo,
  });

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['deskripsi'] = deskripsi;
    map['jumlah'] = jumlah;
    map['jatuhtempo'] = jatuhtempo;
    return map;
  }

  Utang.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.deskripsi = map['deskripsi'];
    this.jumlah = map['jumlah'];
    this.jatuhtempo = map['jatuhtempo'];
  }
}
