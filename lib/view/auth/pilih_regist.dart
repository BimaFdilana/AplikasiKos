// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kos_tes/view/auth/login.dart';
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:kos_tes/view/screen/admin/admin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/pemilik/nav_bar.dart';
import '../screen/pencari/nav_bar.dart';
import 'regist_pemilik.dart';
import 'regist_pencari.dart';

class PilihRegist extends StatefulWidget {
  const PilihRegist({super.key});

  @override
  State<PilihRegist> createState() => _PilihRegistState();
}

enum LoginStatus { notSignIn, signInPemilik, signInPencari, signInAdmin }

class _PilihRegistState extends State<PilihRegist> {
  LoginStatus _loginStatus = LoginStatus.notSignIn;

  savePref(
    int value,
    String username,
    String email,
    String role,
    String id,
  ) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt('value', value);
      preferences.setString('username', username);
      preferences.setString('email', email);
      preferences.setString("role", role);
      preferences.setString("id", id);

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
            elevation: 0,
            toolbarHeight: 5.0,
            backgroundColor: MyColors.khijau0,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              SvgPicture.asset(
                "assets/images/splash_bg2.svg",
                fit: BoxFit.cover,
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Selamat Datang',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                'Ayo bergabung! dan temukan kos pilihan anda',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Image.asset(
                                  'assets/images/gambar1.png',
                                  fit: BoxFit.cover,
                                  width: 300,
                                  height: 300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Daftar Sebagai',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          width: constraints.maxWidth,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Register1()));
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
                                  'Pemilik',
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
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          width: constraints.maxWidth,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Register2()));
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
                                  'Pencari',
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
                                builder: (context) => const Login(),
                              ),
                            );
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
        return AdminPage(signOut: signOut);
        break;
    }
  }
}
