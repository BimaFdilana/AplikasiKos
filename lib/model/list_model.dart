// ignore_for_file: non_constant_identifier_names

class ListModel {
  final String id;
  final String nama;
  final String no_hp;
  final String harga;
  final String alamat;
  final String j_kelamin;
  final String f_kos;
  final String fkeaman;
  final String fumum;
  final String image;
  final String idUsers;
  final String lat;
  final String lng;
  final String username;
  final String createdDate;

  ListModel({
    required this.id,
    required this.nama,
    required this.no_hp,
    required this.harga,
    required this.alamat,
    required this.j_kelamin,
    required this.f_kos,
    required this.fkeaman,
    required this.fumum,
    required this.image,
    required this.idUsers,
    required this.lat,
    required this.lng,
    required this.username,
    required this.createdDate,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'],
      nama: json['nama'],
      no_hp: json['no_hp'],
      harga: json['harga'],
      alamat: json['alamat'],
      j_kelamin: json['j_kelamin'],
      f_kos: json['f_kos'],
      fkeaman: json['fkeaman'],
      fumum: json['fumum'],
      image: json['image'],
      idUsers: json['idUsers'],
      lat: json['lat'],
      lng: json['lng'],
      username: json['username'],
      createdDate: json['createdDate'],
    );
  }
}
