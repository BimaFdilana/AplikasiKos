// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:http/http.dart' as http;
// import 'package:kos_tes/view/screen/pemilik/tambah_kos.dart';

import '../../../api/api_con.dart';
import '../../../model/kos_model.dart';

class DetailSettingK extends StatefulWidget {
  const DetailSettingK({super.key});

  @override
  State<DetailSettingK> createState() => _DetailSettingKState();
}

class _DetailSettingKState extends State<DetailSettingK> {
  final uang = NumberFormat("#,##0", "en_US");
  var loading = false;
  KosModel? kList;

  Future<void> lihatKos() async {
    setState(() {
      loading = true;
    });

    // await getPref();

    final response = await http.get(Uri.parse(ApiCon.lihatKos));
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
        kList = ab;
      });
      setState(() {
        loading = false;
      });
    }
  }

  delete(String id) async {
    final response =
        await http.post(Uri.parse(ApiCon.hapusKos), body: {"idKos": id});
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pop(context);
        lihatKos();
      });
    } else {
      print(pesan);
    }
  }

  @override
  void initState() {
    super.initState();
    // getPref();
    lihatKos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Detail Kos'),
        centerTitle: true,
        backgroundColor: MyColors.khijau0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          delete(kList!.id);
        },
        backgroundColor: MyColors.khijau0,
        icon: const Icon(Icons.leave_bags_at_home),
        label: const Text(
          "Kamar sudah penuh",
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Image.network(
                  'https://bengkaliskost.com/api/upload/${kList?.image}',
                  fit: BoxFit.cover,
                  width: 100,
                  height: 200,
                ),
                Card(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${kList?.nama} -',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25.0,
                              ),
                            ),
                            Text(
                              ' Tipe untuk ${kList?.j_kelamin}',
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined),
                            Text(
                              kList!.alamat,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2, top: 10),
                              child: Text(
                                'Rp. ${uang.format(int.parse(kList!.harga))} /bulan',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            const Icon(Icons.favorite)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Container(
                  color: Colors.grey[200],
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Yang kamu dapatkan di Sini !',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.app_registration_sharp),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bengkalis Kos',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        'Aplikasi kompleks yang mudah diakses \ndan pastinya aman',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  Icon(Icons.home_repair_service_rounded),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Pro service',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        'Ditangani secara profesional oleh tim\nBengkalis kos.Selama kamu mencari\ninformasi kos disini',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                // Row(
                //   children: [
                //     ElevatedButton(
                //       onPressed: () {
                //         delete(kList!.id);
                //       },
                //       child: const Text('data'),
                //     ),
                //     ElevatedButton(
                //       onPressed: () {},
                //       child: const Text('data'),
                //     ),
                //   ],
                // ),
                // Container(
                //   color: Colors.grey[200],
                //   child: Card(
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10)),
                //     child: const Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Padding(
                //           padding: EdgeInsets.all(15.0),
                //           child: Text(
                //             'Comment',
                //             style: TextStyle(
                //               fontWeight: FontWeight.bold,
                //               // fontSize: 20.0,
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
    );
  }
}
