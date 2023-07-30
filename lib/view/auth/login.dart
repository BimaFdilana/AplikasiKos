// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print, dead_code

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:kos_tes/view/auth/pilih_regist.dart';
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:kos_tes/view/screen/admin/admin_page.dart';
import 'package:kos_tes/view/screen/pemilik/nav_bar.dart';
import 'package:kos_tes/view/screen/pencari/nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_con.dart';
// import '../screen/nav_bar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

enum LoginStatus { notSignIn, signInPemilik, signInPencari, signInAdmin }

class _LoginState extends State<Login> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  final formKey = GlobalKey<FormState>();
  String? email, password;

  bool secureText = true;

  showHide() {
    setState(() {
      secureText = !secureText;
    });
  }

  submitForm() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      login();
    }
  }

  login() async {
    final response = await http.post(Uri.parse(ApiCon.login),
        body: {"email": email, "password": password});

    final data = jsonDecode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    String usernameAPI = data['username'];
    String emailAPI = data['email'];
    String role = data['role'];
    String id = data['id'];
    String image = data['image'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signInPencari;
        _loginStatus = LoginStatus.signInPemilik;
        _loginStatus = LoginStatus.signInAdmin;
        savePref(value, usernameAPI, emailAPI, role, id, image);
      });
      print(pesan);
    } else {
      print(pesan);
    }
  }

  savePref(
    int value,
    String username,
    String email,
    String role,
    String id,
    String image,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt('value', value);
      preferences.setString('username', username);
      preferences.setString('email', email);
      preferences.setString("role", role);
      preferences.setString("id", id);
      preferences.setString("image", image);

      if (role == "pencari") {
        _loginStatus = LoginStatus.signInPencari;
      } else if (role == "pemilik") {
        _loginStatus = LoginStatus.signInPemilik;
      } else if (role == "admin") {
        _loginStatus = LoginStatus.signInAdmin;
      } else {
        _loginStatus = LoginStatus.notSignIn;
      }
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      String? role = preferences.getString("role");

      if (role == "pencari") {
        _loginStatus = LoginStatus.signInPencari;
      } else if (role == "pemilik") {
        _loginStatus = LoginStatus.signInPemilik;
      } else if (role == "admin") {
        _loginStatus = LoginStatus.signInAdmin;
      } else {
        _loginStatus = LoginStatus.notSignIn;
      }
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("role");
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  reload() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return Scaffold(
          appBar: AppBar(
            backgroundColor: MyColors.khijau0,
            toolbarHeight: 5.0,
          ),
          resizeToAvoidBottomInset: false,
          body: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(
                "assets/images/splash_bg1.svg",
                fit: BoxFit.cover,
              ),
              GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SafeArea(
                  child: Form(
                    key: formKey,
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                        ),
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: MyColors.khijau0),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 25.0,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Email',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
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
                                cursorColor: MyColors.khijau0,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'contoh@gmail.com',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: MyColors.khijau0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  'Password',
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                obscureText: secureText,
                                validator: (e) {
                                  if (e!.isEmpty) {
                                    return 'Password tidak boleh kosong';
                                  }
                                  return null;
                                },
                                onSaved: (e) {
                                  password = e!;
                                },
                                cursorColor: MyColors.khijau0,
                                decoration: InputDecoration(
                                  hintText: '*****',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                        color: MyColors.khijau0),
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
                            builder: (BuildContext context,
                                BoxConstraints constraints) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                width: constraints.maxWidth,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: () {
                                    submitForm();
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
                                        'Masuk',
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
                                "Belum memiliki akun?",
                                style: TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PilihRegist()));
                                },
                                child: const Text(
                                  "Daftar",
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
        break;
      case LoginStatus.signInPemilik:
        return NavBar2(signOut);
        break;
      case LoginStatus.signInPencari:
        return NavBar1(signOut);
        break;
      case LoginStatus.signInAdmin:
        return AdminPage(signOut: signOut,);
    }
  }
}
