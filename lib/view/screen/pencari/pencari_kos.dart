import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kos_tes/view/pages/constractor.dart';

import '../../../api/api_con.dart';
import '../../../model/list_model.dart';
import '../other/detail_kos.dart';

class PencariKos extends StatefulWidget {
  const PencariKos({super.key});

  @override
  State<PencariKos> createState() => _PencariKosState();
}

class _PencariKosState extends State<PencariKos> {
  List<ListModel> list = [];
  var loading = false;
  Set<Circle> circle = HashSet<Circle>();

  String? username = "", role = "", email = "", id = "";

  void setCircless() {
    circle.add(
      const Circle(
        circleId: CircleId('0'),
        center: LatLng(1.4578999, 102.1505621),
        radius: 500,
        strokeWidth: 0,
        fillColor: Color.fromRGBO(12, 5, 1, .5),
      ),
    );
  }

  Future lihatKos() async {
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
    setCircless();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.khijau0,
        title: const Text('Kos terdekat'),
      ),
      body: Stack(
        children: [
          _tampilkanPetaDenganPenanda(),
          if (loading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _tampilkanPetaDenganPenanda() {
    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: const CameraPosition(
        target: LatLng(1.4578999, 102.1505621),
        zoom: 15,
      ),
      circles: circle,
      markers: _buatPenanda(),
    );
  }

//1.45833, long: 102.1532517>
  Set<Marker> _buatPenanda() {
    return list.map((api) {
      return Marker(
        markerId: MarkerId(api.id.toString()),
        position: LatLng(double.parse(api.lat), double.parse(api.lng)),
        infoWindow: InfoWindow(
          title: api.nama,
          snippet: api.alamat,
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DetailKos(model: api)));
          },
        ),
      );
    }).toSet();
  }
}


// Container(
//               height: 300,
//               width: 200,
//               decoration: BoxDecoration(
//                 color: MyColors.kputih,
//                 border: Border.all(color: MyColors.khijau1),
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 300,
//                     height: 100,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: NetworkImage(
//                               'https://datakos1.000webhostapp.com/upload/${api.image}'),
//                           fit: BoxFit.fitWidth,
//                           filterQuality: FilterQuality.medium,
//                         ),
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(10.0),
//                         ),
//                         color: MyColors.khijau0),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(
//                       top: 10,
//                       left: 10,
//                       right: 10,
//                     ),
//                     child: Column(
//                       children: [
//                         Text(api.nama),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );