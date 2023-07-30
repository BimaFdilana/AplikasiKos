// ignore_for_file: avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../api/api_con.dart';
import '../../../model/list_model.dart';
import '../../pages/constractor.dart';
import 'detail_kos.dart';

class SearchKos extends StatefulWidget {
  const SearchKos({super.key});

  @override
  State<SearchKos> createState() => _SearchKosState();
}

class _SearchKosState extends State<SearchKos> {
  List<ListModel> list = [];
  List<ListModel> listSearch = [];
  var loading = false;
  final uang = NumberFormat("#,##0", "en_US");

  lihatKos() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(ApiCon.lihatKos));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      setState(() {
        for (Map<String, dynamic> i in data) {
          list.add(ListModel.fromJson(i));
        }
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  TextEditingController searchController = TextEditingController();

  onSearch(String text) async {
    listSearch.clear();
    if (text.isEmpty) {
      setState(() {});
    }
    list.forEach((a) {
      if (a.nama.toLowerCase().contains(text)) {
        listSearch.add(a);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    lihatKos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.khijau0,
        toolbarHeight: 5.0,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: searchController,
                onChanged: onSearch,
                autofocus: true,
                cursorColor: MyColors.khijau0,
                decoration: InputDecoration(
                  fillColor: MyColors.kputih,
                  filled: true,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  hintText: 'Temukan Kos!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: MyColors.khijau0),
                  ),
                ),
              ),
            ),
            Container(
              child: loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : searchController.text.isNotEmpty || listSearch.isNotEmpty
                      ? Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisExtent: 285,
                                    mainAxisSpacing: 10),
                                    itemCount: listSearch.length,
                            itemBuilder: (context, i) {
                              final a = listSearch[i];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailKos(model: a,)));
                                },
                                child: Card(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: MyColors.kputih,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.grey,
                                          spreadRadius: 0,
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Hero(
                                            tag: a.id,
                                            child: Image.network(
                                              'https://bengkaliskost.com/api/upload/${a.image}',
                                              width: MediaQuery.of(context).size.width / 2,
                                              height:
                                                  MediaQuery.of(context).size.height / 5, // Atur ukuran gambar sesuai kebutuhan
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: MyColors.khitam)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(1),
                                              child: Text(
                                                a.j_kelamin, // Ganti dengan nama barang sesuai kebutuhan
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                a.nama,
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.location_on_outlined),
                                                Expanded(
                                                  child: Text(
                                                    a.alamat,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Text(
                                                'Rp. ${uang.format(int.parse(a.harga))} /bulan',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 10),
                                              child: Text(
                                                '${a.f_kos},${a.fkeaman}, ${a.fumum}',
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(16),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Cari Kos yang kamu inginkan!',
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
