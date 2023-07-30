// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:path/path.dart' as path;
import 'package:kos_tes/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_con.dart';

class EditProfile extends StatefulWidget {
  final UsersModel model;
  final bool reload;
  const EditProfile({super.key, required this.model, required this.reload});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  final key = GlobalKey<FormState>();
  File? imageFile;
  String? id, username, email, password, role;

  TextEditingController? txtUsername, txtEmail, txtPassword, txtRole;

  setup() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
    });
    txtUsername = TextEditingController(text: widget.model.username);
    txtEmail = TextEditingController(text: widget.model.email);
    txtPassword = TextEditingController(text: widget.model.password);
    txtRole = TextEditingController(text: widget.model.role);
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
      var uri = Uri.parse(ApiCon.editUser);
      var request = http.MultipartRequest("POST", uri);
      request.fields['username'] = username ?? '';
      request.fields['email'] = email ?? '';
      request.fields['password'] = password ?? '';
      request.fields['role'] = role ?? '';
      request.fields['idUser'] = widget.model.id;
      request.files.add(http.MultipartFile("image", stream, length,
          filename: path.basename(imageFile!.path)));
      var response = await request.send();
      if (response.statusCode > 2) {
        print("image upload");
        setState(() {
          widget.reload;
          Navigator.pop(context);
        });
      } else {
        print("image failed");
      }
    } catch (e) {
      debugPrint("Error $e");
    }
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
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.khijau0,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: MyColors.kputih,
          ),
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
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Username',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: txtUsername,
                      onSaved: (e) {
                        username = e ?? '';
                      },
                      enableInteractiveSelection: true,
                      cursorColor: MyColors.khijau0,
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: MyColors.khijau0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: txtEmail,
                      onSaved: (e) {
                        email = e ?? '';
                      },
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(
                        hintText: 'contoh@gmail.com',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: MyColors.khijau0),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Password',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      readOnly: true,
                      controller: txtPassword,
                      onSaved: (e) {
                        password = e ?? '';
                      },
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(
                        hintText: '*****',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'role',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      readOnly: true,
                      controller: txtRole,
                      onSaved: (e) {
                        role = e ?? '';
                      },
                      enableInteractiveSelection: true,
                      decoration: InputDecoration(
                        hintText: 'Role',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
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
                      height: 10,
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
