import 'package:flutter/material.dart';
import 'package:kos_tes/view/pages/constractor.dart';

class NotifikasiKos extends StatefulWidget {
  const NotifikasiKos({super.key});

  @override
  State<NotifikasiKos> createState() => _NotifikasiKosState();
}

class _NotifikasiKosState extends State<NotifikasiKos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: MyColors.khijau0,
        title: const Text('Notifikasi Kos'),
        centerTitle: true,
      ),
    );
  }
}