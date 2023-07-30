// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:kos_tes/view/pages/constractor.dart';

import '../../api/api_con.dart';
import 'login.dart';

class Register1 extends StatefulWidget {
  const Register1({super.key});

  @override
  State<Register1> createState() => _Register1State();
}

class _Register1State extends State<Register1> {
  String? username, email, password, role, image;
  final key = GlobalKey<FormState>();

  bool secureText = true;

  showHide() {
    setState(() {
      secureText = !secureText;
    });
  }

  submitRegist() {
    final form = key.currentState;
    if (form!.validate()) {
      form.save();
      regist1();
    }
  }

  regist1() async {
    final response = await http.post(Uri.parse(ApiCon.register), body: {
      "username": username,
      "email": email,
      "password": password,
      "role": 'pemilik',
      "image": 'placeholderUser.jpg'
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(pesan),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MyColors.khijau0,
        centerTitle: true,
        title: const Text('Daftar Pemilik Kos'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset(
            "assets/images/splash_bg3.svg",
            fit: BoxFit.cover,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SafeArea(
              child: Form(
                key: key,
                child: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(1),
                            child: Image.asset(
                              'assets/images/pemilik.png',
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Username',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'Username tidak boleh kosong';
                              }
                              return null;
                            },
                            onSaved: (e) {
                              username = e!;
                            },
                            cursorColor: MyColors.khijau0,
                            decoration: InputDecoration(
                              hintText: 'username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: MyColors.khijau0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Email',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'Email tidak boleh kosong';
                              }
                              return null;
                            },
                            onSaved: (e) {
                              email = e!;
                            },
                            decoration: InputDecoration(
                              hintText: 'contoh@gmail.com',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: MyColors.khijau0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: const Text(
                              'Password',
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          TextFormField(
                            validator: (e) {
                              if (e!.isEmpty) {
                                return 'Password tidak boleh kosong';
                              }
                              return null;
                            },
                            obscureText: secureText,
                            onSaved: (e) {
                              password = e!;
                            },
                            decoration: InputDecoration(
                              hintText: '*****',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    const BorderSide(color: MyColors.khijau0),
                              ),
                              suffixIcon: IconButton(
                                color: secureText
                                    ? MyColors.khijau3
                                    : MyColors.khijau2,
                                onPressed: showHide,
                                icon: Icon(secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 25.0,
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
                                submitRegist();
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
                                    'Daftar',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sudah Memiliki Akun?",
                            style: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            child: const Text(
                              "Masuk",
                              style: TextStyle(color: MyColors.khijau0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
