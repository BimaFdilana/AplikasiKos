// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kos_tes/api/api_con.dart';
import 'package:kos_tes/model/kos_model.dart';
import 'package:http/http.dart' as http;
import 'package:kos_tes/view/pages/constractor.dart';
// import 'package:kos_tes/view/pages/constractor.dart';
import 'package:kos_tes/view/screen/pemilik/edit_kos.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'form_kos.dart';

class UserAdminPage extends StatefulWidget {
  const UserAdminPage({super.key});

  @override
  State<UserAdminPage> createState() => _UserAdminPageState();
}

class _UserAdminPageState extends State<UserAdminPage> {
  var loading = false;
  final list = <KosModel>[];
  // String? id = "";
  final uang = NumberFormat("#,##0", "en_US");

  // getPref() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   setState(() {
  //     id = preferences.getString("id");
  //   });
  // }

  Future<void> lihatKos() async {
    list.clear();
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
        list.add(ab);
      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: [
                const Text(
                  "Apakah yakin untuk menghapus?",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text('No'),
                    ),
                    const SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                      onTap: () {
                        delete(id);
                      },
                      child: const Text('Yes'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Admin Setting Kos Item'),
        backgroundColor: MyColors.khijau1,
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: MyColors.khijau0,
      //   child: const Center(
      //     child: Icon(Icons.assignment_add),
      //   ),
      //   onPressed: () {
      //     Navigator.of(context).push(
      //       MaterialPageRoute(
      //         builder: (context) => FormKos(lihatKos),
      //       ),
      //     );
      //   },
      // ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, i) {
                final x = list[i];
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        'https://datakos1.000webhostapp.com/upload/${x.image}',
                        width: 100.0,
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Id Users : ${x.idUsers}',
                              style:
                                  const TextStyle(fontStyle: FontStyle.italic),
                            ),
                            Text(
                              'Nama kos:\n - ${x.nama}',
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(x.no_hp),
                            Text(
                              x.j_kelamin,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(x.f_kos),
                            Text(x.createdDate),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditKos(x, lihatKos),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          dialogDelete(x.id);
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
