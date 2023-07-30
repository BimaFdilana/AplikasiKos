// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kos_tes/view/pages/constractor.dart';
// import 'package:kos_tes/view/screen/pemilik/form_kos.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapKosTambah extends StatefulWidget {
  const MapKosTambah({super.key});

  @override
  State<MapKosTambah> createState() => _MapKosTambahState();
}

class _MapKosTambahState extends State<MapKosTambah> {
  double? userLat;
  double? userLng;

  Future<void> getUserLocation() async {
    Location location = Location();
    final locationData = await location.getLocation();
    print(locationData);

    setState(() {
      userLat = locationData.latitude;
      userLng = locationData.longitude;
    });

    saveLatlang(locationData);
  }

  saveLatlang(LocationData locationData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setDouble('userLat', locationData.latitude!);
      preferences.setDouble('userLng', locationData.longitude!);
      print(locationData);
    });
  }

  saveLatlangM(double latitude, double longitude) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setDouble('userLat', latitude);
      preferences.setDouble('userLng', longitude);
    });
  }

  Widget marker() {
    return GoogleMap(
      mapType: MapType.terrain,
      initialCameraPosition: const CameraPosition(
        target: LatLng(1.4578999, 102.1505621),
        zoom: 15,
      ),
      markers: penandaM(),
      onTap: (LatLng latLang) {
        setState(() {
          userLat = latLang.latitude;
          userLng = latLang.longitude;
          print('Marker_${userLat}_$userLng');
        });
        saveLatlangM(latLang.latitude, latLang.longitude);
      },
    );
  }

  Set<Marker> penandaM() {
    if (userLat != null && userLng != null) {
      return {
        Marker(
          markerId: MarkerId('Marker_${userLat}_$userLng'),
          position: LatLng(userLat!, userLng!),
        ),
      };
    } else {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          marker(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    getUserLocation();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_location_alt_rounded, color: Colors.grey),
                      SizedBox(width: 8),
                      Text(
                        'Lokasi Anda',
                        style: TextStyle(
                          fontSize: 16,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: MyColors.khijau0,
                    onPrimary: MyColors.khijau1,
                    padding: const EdgeInsets.symmetric(),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Selesai',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: MyColors.kputih),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
