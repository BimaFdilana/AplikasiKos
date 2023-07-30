import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:kos_tes/model/list_model.dart';
import 'package:kos_tes/view/filter/campur.dart';
import 'package:kos_tes/view/filter/fasilitas_kos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../api/api_con.dart';
import '../filter/putra.dart';
import '../filter/putri.dart';
import '../pages/constractor.dart';
import 'other/detail_kos.dart';
import 'other/search_kos.dart';
// import 'other/detail_kos.dart';
// import 'other/search_kos.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var loading = false;
  List images = [
    "https://bengkaliskost.com/api/upload/Banner1.png",
    "https://bengkaliskost.com/api/upload/Banner2.png",
    "https://bengkaliskost.com/api/upload/Banner3.png"
  ];
  List<ListModel> list = [];
  final uang = NumberFormat(
    "#,##0",
    "en_US",
  );
  String? username = "", role = "", email = "", id = "";
  var selectedService = 0;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      email = preferences.getString("email");
      role = preferences.getString("role");
      id = preferences.getString("id");
    });
  }

  lihatKos() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse(ApiCon.lihatKos));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
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

  @override
  void initState() {
    super.initState();
    lihatKos();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: MyColors.khijau0,
        toolbarHeight: MediaQuery.of(context).size.height / 100,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            _greetings(),
            const SizedBox(
              height: 16,
            ),
            _card(),
            const SizedBox(
              height: 10,
            ),
            _search(),
            const SizedBox(
              height: 16,
            ),
            _services(),
            const SizedBox(
              height: 10,
            ),
            _kos()
          ],
        ),
      )),
    );
  }

  ListView _kos() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      separatorBuilder: (context, index) => const SizedBox(
        height: 11,
      ),
      itemCount: list.length,
      itemBuilder: (context, i) {
        final x = list[i];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DetailKos(model: x),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF35385A).withOpacity(.12),
                      blurRadius: 30,
                      offset: const Offset(0, 2))
                ]),
            child: Row(
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Hero(
                    tag: x.id,
                    child: Image.network(
                      'https://bengkaliskost.com/api/upload/${x.image}',
                      width: MediaQuery.of(context).size.width / 4,
                      height: MediaQuery.of(context).size.height / 8,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: MyColors.khitam),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(1),
                            child: Text(
                              x.j_kelamin, // Ganti dengan nama barang sesuai kebutuhan
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        x.nama,
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF3F3E3F),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Rp. ${uang.format(int.parse(x.harga))} /bulan",
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Color(0xFFACA3A3),
                          ),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Text(
                              x.alamat,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                color: const Color(0xFFACA3A3),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Row(
                        children: [
                          Text(
                            "Klik for detail",
                            style: GoogleFonts.manrope(
                                color: const Color(0xFF50CC98),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  SizedBox _services() {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 20,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FasilitasKosFilter()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: MyColors.khijau2),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.format_list_bulleted_rounded,
                        size: 25,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Filter Fasilitas")
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PutraFilter()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: MyColors.khijau2),
                  child: const Text('Putra'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const PutriFilter()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: MyColors.khijau2),
                  child: const Text('Putri'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CampurFilter()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: MyColors.khijau2),
                  child: const Text('Campur'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 30,
                ),
              ],
            ),
          ],
        ));
  }

  Widget _search() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchKos(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14),
        ),
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            hintText: "Temukan Kos ...",
            hintStyle: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFCACACA),
                height: 150 / 100),
          ),
        ),
      ),
    );
  }

  Column _card() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height / 4,
            aspectRatio: 1,
            viewportFraction: 1,
            autoPlay: true,
          ),
          items: images.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width / 1,
                    // color: Colors.amber,
                    child: Image.network(
                      i,
                      fit: BoxFit.cover,
                      // width: MediaQuery.of(context).size.width / 1,
                    ));
              },
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images
              .map((e) => Container(
                    width: 5,
                    height: 5,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 3.0,
                      vertical: 8.0,
                    ),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.khijau3,
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Padding _greetings() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.03,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hallo. $username',
              style: GoogleFonts.manrope(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF3F3E3F),
              ),
            ),
            Text(
              'Temukan yang kamu inginkan !',
              style: GoogleFonts.manrope(),
            ),
          ],
        ),
      ),
    );
  }
}

//

// GestureDetector(
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () {
// Navigator.push(context,
//     MaterialPageRoute(builder: (context) => const SearchKos()));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.all(8),
//                 child: TextFormField(
//                   cursorColor: MyColors.khijau0,
//                   decoration: InputDecoration(
//                     enabled: false,
//                     fillColor: MyColors.kputih,
//                     filled: true,
//                     prefixIcon: const Icon(
//                       Icons.search,
//                       color: Colors.grey,
//                     ),
//                     hintText: 'Temukan Kos!',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                       borderSide: const BorderSide(color: MyColors.khijau0),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Column(
//               children: [
//                 const SizedBox(
//                   height: 15,
//                 ),
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width / 1.03,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Holla. $username',
//                         style: const TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold),
//                       ),
//                       const Text('Temukan yang kamu inginkan !'),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15.0,
//                 ),
//                 Container(
//                   width: MediaQuery.of(context).size.width / 1.03,
//                   height: MediaQuery.of(context).size.height / 4,
//                   decoration: BoxDecoration(
//                     color: MyColors.kputih,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: const [
//                       BoxShadow(
//                         color: Colors.grey,
//                         spreadRadius: 0,
//                         blurRadius: 5,
//                         offset: Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(10),
//                     child: Image.asset(
//                       'assets/images/placeholder.jpg',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 15.0,
//                 ),
//                 Expanded(
//                   child: loading
//                       ? const Center(
//                           child: CircularProgressIndicator(),
//                         )
//                       : GridView.builder(
//                           gridDelegate:
//                               const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 2,
//                                   mainAxisExtent: 285,
//                                   mainAxisSpacing: 10),
//                           itemCount: list.length,
//                           itemBuilder: (context, i) {
//                             final x = list[i];
//                             return InkWell(
//                               onTap: () {
// Navigator.of(context).push(MaterialPageRoute(
//     builder: (context) => DetailKos(model: x)));
//                               },
//                               child: Card(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: MyColors.kputih,
//                                     borderRadius: BorderRadius.circular(20),
//                                     boxShadow: const [
//                                       BoxShadow(
//                                         color: Colors.grey,
//                                         spreadRadius: 0,
//                                         blurRadius: 5,
//                                         offset: Offset(0, 3),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       ClipRRect(
//                                         borderRadius: BorderRadius.circular(10),
//                                         child: Hero(
//                                           tag: x.id,
//                                           child: Image.network(
//                                             'https://datakos1.000webhostapp.com/upload/${x.image}',
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width /
//                                                 2,
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height /
//                                                 5, // Atur ukuran gambar sesuai kebutuhan
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
// Padding(
//   padding: const EdgeInsets.all(8.0),
//   child: Container(
//     decoration: BoxDecoration(
//         borderRadius:
//             BorderRadius.circular(5),
//         border: Border.all(
//             color: MyColors.khitam)),
//     child: Padding(
//       padding: const EdgeInsets.all(1),
//       child: Text(
//         x.j_kelamin, // Ganti dengan nama barang sesuai kebutuhan
//         style: const TextStyle(
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   ),
// ),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(left: 8),
//                                             child: Text(
//                                               x.nama,
//                                               style: const TextStyle(
//                                                   fontSize: 15,
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           Row(
//                                             children: [
//                                               const Icon(
//                                                   Icons.location_on_outlined),
//                                               Expanded(
//                                                 child: Text(
//                                                   x.alamat,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Padding(
//                                             padding:
//                                                 const EdgeInsets.only(left: 8),
//                                             child: Text(
//                                               'Rp. ${uang.format(int.parse(x.harga))} /bulan',
//                                               style: const TextStyle(
//                                                   fontWeight: FontWeight.bold),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 8, right: 10),
//                                             child: Text(
//                                               '${x.f_kos},${x.fkeaman}, ${x.fumum}',
//                                               overflow: TextOverflow.ellipsis,
//                                               style: const TextStyle(
//                                                   fontStyle: FontStyle.italic),
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
