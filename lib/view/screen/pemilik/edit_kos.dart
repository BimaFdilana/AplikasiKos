// ignore_for_file: avoid_print, deprecated_member_use

// import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:kos_tes/api/api_con.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/kos_model.dart';

class EditKos extends StatefulWidget {
  final KosModel model;
  final VoidCallback reload;
  const EditKos(this.model, this.reload, {super.key});

  @override
  State<EditKos> createState() => _EditKosState();
}

class _EditKosState extends State<EditKos> {
  final key = GlobalKey<FormState>();
  File? imageFile;
  List<String> pilihFkos = [];
  List<String> pilihFkeaman = [];
  List<String> pilihFumum = [];
  String? nama, noHp, harga, alamat, jKelamin, fKos, fkeaman, fumum, idUsers;

  TextEditingController? txtNama, txtnoHp, txtHarga, txtAlamat;

  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idUsers = preferences.getString("id");
    });
    txtNama = TextEditingController(text: widget.model.nama);
    txtnoHp = TextEditingController(text: widget.model.no_hp);
    txtHarga = TextEditingController(text: widget.model.harga);
    txtAlamat = TextEditingController(text: widget.model.alamat);
    pilihFkos = widget.model.f_kos.split(",");
    pilihFkeaman = widget.model.fkeaman.split(",");
    pilihFumum = widget.model.fumum.split(",");

    if (widget.model.j_kelamin == 'Laki-laki' ||
        widget.model.j_kelamin == 'Perempuan' ||
        widget.model.j_kelamin == 'Campur') {
      jKelamin = widget.model.j_kelamin;
    } else {
      jKelamin = null;
    }
  }

  check() {
    final form = key.currentState;
    if (form!.validate()) {
      form.save();
      submit();
    } else {}
  }

  submit() async {
    try {
      var stream =
          http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
      var length = await imageFile!.length();
      var uri = Uri.parse(ApiCon.editKos);
      var request = http.MultipartRequest("POST", uri);
      request.fields['nama'] = nama ?? '';
      request.fields['no_hp'] = noHp ?? '';
      request.fields['harga'] = harga ?? '';
      request.fields['alamat'] = alamat ?? '';
      request.fields['j_kelamin'] = jKelamin ?? '';
      request.fields['f_kos'] = fKos ?? '';
      request.fields['fkeaman'] = fkeaman ?? '';
      request.fields['fumum'] = fumum ?? '';
      request.fields['idKos'] = widget.model.id;
      request.fields['idUsers'] = idUsers ?? '';
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(imageFile!.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
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
    // final response = await http.post(Uri.parse(ApiCon.editKos), body: {
    //   "nama": nama,
    //   "no_hp": noHp,
    //   "harga": harga,
    //   "alamat": alamat,
    //   "j_kelamin": jKelamin,
    //   "f_kos": fKos,
    //   "fkeaman": fkeaman,
    //   "fumum": fumum,
    //   "idKos": widget.model.id,
    // });
    // final data = jsonDecode(response.body);
    // int value = data['value'];
    // String pesan = data['message'];
    // if (value == 1) {
    //   setState(() {
    //     widget.reload();
    //     Navigator.pop(context);
    //   });
    // } else {
    //   print(pesan);
    // }
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

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.khijau0,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Update Informasi Kost!',
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
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: txtNama,
                      onSaved: (e) {
                        nama = e ?? '';
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
                        'NoHandphone',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: txtnoHp,
                      onSaved: (e) {
                        noHp = e ?? '';
                      },
                      keyboardType: TextInputType.phone,
                      enableInteractiveSelection: true,
                      cursorColor: MyColors.khijau0,
                      decoration: InputDecoration(
                        hintText: 'Nomor Hp/Wa',
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
                      controller: txtHarga,
                      onSaved: (e) {
                        harga = e ?? '';
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
                      controller: txtAlamat,
                      onSaved: (e) {
                        alamat = e ?? '';
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
                            hint: const Text('Jenis Kos'),
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 30,
                            elevation: 8,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                            onChanged: (String? newValue) {
                              setState(() {
                                jKelamin = newValue ?? '';
                              });
                            },
                            items: <String>[
                              'Laki-laki',
                              'Perempuan',
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
                                value: pilihFkos.contains('lemari'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFkos.contains('kasur'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFkos.contains('bantal'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFkos.contains('meja'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
                                      pilihFkos.add('meja');
                                    } else {
                                      pilihFkos.remove('meja');
                                    }
                                    fKos = pilihFkos.join(',');
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
                                value: pilihFkos.contains('kipas angin'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
                                      pilihFkos.add('kipas angin');
                                    } else {
                                      pilihFkos.remove('kipas angin');
                                    }
                                    fKos = pilihFkos.join(',');
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
                                value: pilihFkeaman.contains('CCTV'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFkeaman.contains('trali'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFkeaman.contains('pagar'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFumum.contains('wifi'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                          Row(
                            children: [
                              Checkbox(
                                value: pilihFumum.contains('pengurus kos'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFumum.contains('jemuran'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFumum.contains('parkir motor'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                                value: pilihFumum.contains('dapur'),
                                onChanged: (value) {
                                  setState(() {
                                    if (value != null && value) {
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
                    SizedBox(
                      width: double.infinity,
                      height: 150.0,
                      child: InkWell(
                        onTap: () {
                          showImageSourceOptions();
                        },
                        child: imageFile == null
                            ? Image.network(
                                "https://bengkaliskost.com/api/upload/${widget.model.image}")
                            : Image.file(
                                imageFile != null
                                    ? File(imageFile!.path)
                                    : File('placeholder'),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 15.0,
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
                              setState(() {
                                check();
                              });
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
                                  'Update',
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
