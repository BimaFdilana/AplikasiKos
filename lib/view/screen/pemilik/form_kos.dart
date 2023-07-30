// ignore_for_file: avoid_print, deprecated_member_use

// import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
// import 'package:intl/intl.dart';
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:kos_tes/view/screen/pemilik/map_kos.dart';
import 'package:kos_tes/view/screen/pemilik/tambah_kos.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
// import 'package:location/location.dart';
import 'package:kos_tes/view/pages/currency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api/api_con.dart';

class FormKos extends StatefulWidget {
  final VoidCallback reload;
  const FormKos(this.reload, {super.key});

  @override
  State<FormKos> createState() => _FormKosState();
}

class _FormKosState extends State<FormKos> {
  List<String> pilihFkos = [];
  List<String> pilihFkeaman = [];
  List<String> pilihFumum = [];
  String? nama, noHp, harga, alamat, jKelamin, fKos, fkeaman, fumum, idUsers;
  double? userLat;
  double? userLng;
  final key = GlobalKey<FormState>();
  File? imageFile;
  // LocationData? locationData2;

  // Future<void> getUserLocation() async {
  //   Location location = Location();
  //   final locationData = await location.getLocation();
  //   print(locationData);

  //   setState(() {
  //     locationData2 = locationData;
  //   })
  // }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
      userLat = preferences.getDouble("userLat");
      userLng = preferences.getDouble("userLng");
    });
  }

  showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  pilihGambar();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil dengan Kamera'),
                onTap: () {
                  Navigator.of(context).pop();
                  pilihKamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  pilihGambar() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1920.0,
      maxWidth: 1080.0,
    );
    setState(() {
      if (image != null) {
        imageFile = File(image.path);
      }
    });
  }

  pilihKamera() async {
    var imagePicker = ImagePicker();
    var image = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1920.0,
      maxWidth: 1080.0,
    );
    setState(() {
      if (image != null) {
        imageFile = File(image.path);
      }
    });
  }

  check() {
    final form = key.currentState;
    if (form!.validate()) {
      form.save();
      simpan();
    }
  }

  simpan() async {
    await getPref();
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
      var length = await imageFile!.length();
      var uri = Uri.parse(ApiCon.tambahKos);
      var request = http.MultipartRequest("POST", uri);
      request.fields['nama'] = nama ?? '';
      request.fields['no_hp'] = noHp ?? '';
      request.fields['harga'] = (harga ?? '').replaceAll(",", "");
      request.fields['alamat'] = alamat ?? '';
      request.fields['j_kelamin'] = jKelamin ?? '';
      request.fields['f_kos'] = fKos ?? '';
      request.fields['fkeaman'] = fkeaman ?? '';
      request.fields['fumum'] = fumum ?? '';
      request.fields['idUsers'] = idUsers ?? '';
      request.files.add(
        http.MultipartFile(
          "image",
          stream,
          length,
          filename: path.basename(imageFile!.path),
        ),
      );
      request.fields['lat'] = userLat.toString();
      request.fields['lng'] = userLng.toString();
      print("$userLat,$userLng");
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        savePrefs(jKelamin ?? '', fKos ?? '', fkeaman ?? '', fumum ?? '');
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  savePrefs(
    String jkelamin,
    String fkos,
    String fkeaman,
    String fumum,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('j_kelamin', jkelamin);
      preferences.setString('f_kos', fkos);
      preferences.setString('fkeaman', fkeaman);
      preferences.setString('fumum', fumum);
    });
  }

  String formatPhoneNumber(String noHp) {
    if (noHp.startsWith('08')) {
      return '62${noHp.substring(1)}';
    } else {
      return noHp;
    }
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Row(
              children: [
                Icon(
                  Icons.add_location_alt_rounded,
                  color: Colors.grey,
                ),
                SizedBox(
                  width: 5,
                ),
                Text("Validasi data"),
              ],
            ),
            content: const Text("Pastikan anda memasukkan data dengan benar"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                },
                child: const Text(
                  "Batal",
                  style: TextStyle(color: MyColors.khijau0),
                ),
              ),
              ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: MyColors.khijau0),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const TambahKos()));
                  setState(() {
                    check();
                  });
                },
                child: const Text("Selesai"),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = SizedBox(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('assets/images/placeholder.jpg'),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.khijau0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Masukkan Informasi Kost!',
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: key,
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 25.0,
                    ),
                    //======================= input ===========/
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Nama Kost',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onSaved: (e) {
                        nama = e!;
                      },
                      enableInteractiveSelection: true,
                      cursorColor: MyColors.khijau0,
                      decoration: InputDecoration(
                        hintText: 'Nama Kos Lengkap',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: MyColors.khijau0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Nomor WA',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onSaved: (e) {
                        noHp = formatPhoneNumber(e!);
                      },
                      keyboardType: TextInputType.phone,
                      enableInteractiveSelection: true,
                      cursorColor: MyColors.khijau0,
                      decoration: InputDecoration(
                        hintText: '+08xxxx',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: MyColors.khijau0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Harga',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyFormat()
                      ],
                      onSaved: (e) {
                        harga = e!;
                      },
                      cursorColor: MyColors.khijau0,
                      keyboardType: TextInputType.number,
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(
                        hintText: 'Harga',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: MyColors.khijau0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Alamat',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      onSaved: (e) {
                        alamat = e!;
                      },
                      enableInteractiveSelection: true,
                      cursorColor: MyColors.khijau0,
                      decoration: InputDecoration(
                        hintText: 'Alamat Lengkap, Jln/Desa/Gg',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(
                            color: MyColors.khijau0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    //======================= Fasilitas kos ===========/
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Jenis Kos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(10.0),
                            value: jKelamin,
                            hint: const Text(
                              'Jenis Kos',
                              style: TextStyle(fontSize: 15),
                            ),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 8,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                            onChanged: (String? newValue) {
                              setState(() {
                                jKelamin = newValue!;
                              });
                            },
                            items: <String>[
                              'Putra',
                              'Putri',
                              'Campur',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Fasilitas Kamar',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFkos.contains('lemari'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkos.add('lemari');
                                    } else {
                                      pilihFkos.remove('lemari');
                                    }
                                    fKos = pilihFkos.join(',');
                                  });
                                },
                              ),
                              const Text('Lemari'),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFkos.contains('kasur'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkos.add('kasur');
                                    } else {
                                      pilihFkos.remove('kasur');
                                    }
                                    fKos = pilihFkos.join(',');
                                  });
                                },
                              ),
                              const Text('Kasur'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFkos.contains('bantal'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkos.add('bantal');
                                    } else {
                                      pilihFkos.remove('bantal');
                                    }
                                    fKos = pilihFkos.join(',');
                                  });
                                },
                              ),
                              const Text('Bantal'),
                            ],
                          ),
                          const SizedBox(
                            width: 14,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value:
                                    pilihFkos.contains('kamar mandi didalam'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkos.add('kamar mandi didalam');
                                    } else {
                                      pilihFkos.remove('kamar mandi didalam');
                                    }
                                    fKos = pilihFkos.join(',');
                                  });
                                },
                              ),
                              const Text('Kamar mandi didalam'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFkos.contains('meja'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkos.add('meja');
                                    } else {
                                      pilihFkos.remove('meja');
                                    }
                                  });
                                },
                              ),
                              const Text('Meja'),
                            ],
                          ),
                          const SizedBox(
                            width: 23,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFkos.contains('kipas angin'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkos.add('kipas angin');
                                    } else {
                                      pilihFkos.remove('kipas angin');
                                    }
                                  });
                                },
                              ),
                              const Text('Kipas angin'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Fasilitas Keamanan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFkeaman.contains('CCTV'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkeaman.add('CCTV');
                                    } else {
                                      pilihFkeaman.remove('CCTV');
                                    }
                                    fkeaman = pilihFkeaman.join(',');
                                  });
                                },
                              ),
                              const Text('CCTV'),
                            ],
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFkeaman.contains('trali'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkeaman.add('trali');
                                    } else {
                                      pilihFkeaman.remove('trali');
                                    }
                                    fkeaman = pilihFkeaman.join(',');
                                  });
                                },
                              ),
                              const Text('Trali'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFkeaman.contains('pagar'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFkeaman.add('pagar');
                                    } else {
                                      pilihFkeaman.remove('pagar');
                                    }
                                    fkeaman = pilihFkeaman.join(',');
                                  });
                                },
                              ),
                              const Text('Pagar'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Fasilitas Umum',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFumum.contains('wifi'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFumum.add('wifi');
                                    } else {
                                      pilihFumum.remove('wifi');
                                    }
                                    fumum = pilihFumum.join(',');
                                  });
                                },
                              ),
                              const Text('Wifi'),
                            ],
                          ),
                          const SizedBox(
                            width: 29,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFumum.contains('pengurus kos'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFumum.add('pengurus kos');
                                    } else {
                                      pilihFumum.remove('pengurus kos');
                                    }
                                    fumum = pilihFumum.join(',');
                                  });
                                },
                              ),
                              const Text('Pengurus kos'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFumum.contains('jemuran'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFumum.add('jemuran');
                                    } else {
                                      pilihFumum.remove('jemuran');
                                    }
                                    fumum = pilihFumum.join(',');
                                  });
                                },
                              ),
                              const Text('Jemuran'),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFumum.contains('parkir motor'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFumum.add('parkir motor');
                                    } else {
                                      pilihFumum.remove('parkir motor');
                                    }
                                    fumum = pilihFumum.join(',');
                                  });
                                },
                              ),
                              const Text('Parkir motor'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                checkColor: MyColors.kputih,
                                value: pilihFumum.contains('dapur'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      pilihFumum.add('dapur');
                                    } else {
                                      pilihFumum.remove('dapur');
                                    }
                                    fumum = pilihFumum.join(',');
                                  });
                                },
                              ),
                              const Text('Dapur'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Tekan kotak untuk memilih gambar kos',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 150.0,
                      child: InkWell(
                        onTap: () {
                          showImageSourceOptions();
                        },
                        child: imageFile == null
                            ? placeholder
                            : Image.file(
                                imageFile != null
                                    ? File(imageFile!.path)
                                    : File('placeholder'),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // showConfirmationDialog(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const MapKosTambah()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_location_alt_rounded,
                                  color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Tambahkan Lokasi Anda!',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          width: constraints.maxWidth,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              showConfirmationDialog(check());
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  colors: [
                                    MyColors.khijau0,
                                    MyColors.khijau1,
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Simpan',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
