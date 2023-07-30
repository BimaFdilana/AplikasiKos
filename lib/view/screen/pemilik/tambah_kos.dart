// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
// import 'package:kos_tes/api/api_con.dart';
import 'package:kos_tes/model/kos_model.dart';
import 'package:http/http.dart' as http;

import 'package:kos_tes/view/pages/constractor.dart';
import 'package:kos_tes/view/screen/pemilik/detail_setting.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'form_kos.dart';

class TambahKos extends StatefulWidget {
  const TambahKos({super.key});

  @override
  State<TambahKos> createState() => _TambahKosState();
}

class _TambahKosState extends State<TambahKos> {
  var loading = false;
  final list = <KosModel>[];
  String? id = "";
  final uang = NumberFormat("#,##0", "en_US");

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
  }

  Future<void> lihatKos() async {
    list.clear();
    setState(() {
      loading = true;
    });

    await getPref();

    final response = await http
        .get(Uri.parse('https://bengkaliskost.com/api/text.php?id=$id'));
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) {
        final ab = KosModel(
          api['id'],
          api['nama'],
          api['no_hp'],
          api['harga'],
          api['alamat'],
          api['j_kelamin'],
          api['f_kos'],
          api['fkeaman'],
          api['fumum'],
          api['image'],
          api['idUsers'],
          api['createdDate'],
        );
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getPref();
    lihatKos();
    print("$id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kos Yang Anda Miliki'),
        backgroundColor: MyColors.khijau0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.khijau0,
        child: const Center(
          child: Icon(Icons.assignment_add),
        ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FormKos(lihatKos),
            ),
          );
        },
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
              ? const Center(child: Text('Data kos belum dimasukkan'))
              : ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final x = list[i];
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const DetailSettingK()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFF35385A).withOpacity(.12),
                                  blurRadius: 30,
                                  offset: const Offset(0, 2))
                            ]),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              'https://bengkaliskost.com/api/upload/${x.image}',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(x.nama),
                                  Text(
                                    x.alamat,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Text(x.no_hp),
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          "Rp. ${uang.format(int.parse(x.harga))} /bulan",
                                      style: GoogleFonts.manrope(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Klik untuk setting",
                                    style: GoogleFonts.manrope(
                                        color: const Color(0xFF50CC98),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            // IconButton(
                            //   onPressed: () {
                            //     Navigator.of(context).push(
                            //       MaterialPageRoute(
                            //         builder: (context) => EditKos(x, lihatKos),
                            //       ),
                            //     );
                            //   },
                            //   icon: const Icon(Icons.edit),
                            // ),
                            // IconButton(
                            //   onPressed: () {
                            //     deleteKos(x.id);
                            //   },
                            //   icon: const Icon(Icons.delete),
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
