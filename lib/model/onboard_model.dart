import 'package:flutter/material.dart';

class OnBoardModel {
  String img;
  String text;
  String desc;
  Color bg;
  Color button;

  OnBoardModel({
    required this.img,
    required this.text,
    required this.desc,
    required this.bg,
    required this.button,
  });
}

List<OnBoardModel> screens = <OnBoardModel> [
  OnBoardModel(
    img: 'assets/images/onboard1.png',
    text: 'Selamat datang di Aplikasi \nPenyewaan Kos!',
    desc: 'Anda dapat langsung melakukan booking kos secara online melalui aplikasi. Prosesnya cepat dan praktis tanpa perlu repot datang ke tempat secara langsung.',
    bg: Colors.white,
    button: const Color(0xFF19AA55),
  ),
  OnBoardModel(
    img: 'assets/images/onboard2.png',
    text: 'Informasi Detail di Aplikasi \nPenyewaan Kos!',
    desc: 'Dapatkan informasi lengkap tentang setiap kos kosan atau rumah sewa, termasuk foto-foto, deskripsi, fasilitas, dan informasi kontak pemilik.',
    bg: Colors.white,
    button: const Color(0xFF19AA55),
  ),
  OnBoardModel(
    img: 'assets/images/onboard3.png',
    text: 'Pencarian Mudah di Aplikasi \nPenyewaan Kos!',
    desc: 'Temukan kos kosan atau rumah sewa yang sesuai dengan preferensi Anda. Anda dapat mencari berdasarkan lokasi, harga, fasilitas, dan lainnya.',
    bg: Colors.white,
    button: const Color(0xFF19AA55),
  ),
];
