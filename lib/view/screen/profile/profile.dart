import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kos_tes/model/user_model.dart';
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:kos_tes/view/pages/size_config.dart';
import 'package:http/http.dart' as http;
import 'package:kos_tes/view/screen/profile/edit_profile.dart';
import 'package:kos_tes/view/screen/profile/layanan.dart';
import 'package:kos_tes/view/screen/profile/riwayat.dart';
import 'package:kos_tes/view/screen/profile/s_dan_k.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final VoidCallback signOut;
  const Profile({Key? key, required this.signOut}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var loading = false;
  UsersModel? uData;
  String? id = "", username = "", role = "";

  void _handleLogout() {
    widget.signOut();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      username = preferences.getString("username");
      role = preferences.getString("role");
    });
  }

  Future<void> userData() async {
    setState(() {
      loading = true;
    });

    await getPref();

    final response = await http.get(
        Uri.parse('https://bengkaliskost.com/api/lihatusers.php?id=$id'));
    if (response.contentLength == 2) {
      // Tindakan yang sesuai ketika response.contentLength == 2
    } else {
      final dUser = jsonDecode(response.body);
      dUser.forEach((api) {
        final ab = UsersModel(
          api['id'],
          api['username'],
          api['email'],
          api['password'],
          api['role'],
          api['image'],
          api['createdDate'],
        );
        uData = ab;
      });
      setState(() {
        loading = false;
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    userData();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [MyColors.khijau1, MyColors.khijau0],
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 110.0,
                        ),
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: uData?.image != null
                              ? NetworkImage(
                                  'https://bengkaliskost.com/api/upload/${uData!.image}',
                                )
                              : null,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        if (uData?.username != null)
                          Text(
                            '${uData?.username}'.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (loading)
                          Text(
                            '$username',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        if (uData?.username != null)
                          Text(
                            '${uData?.role}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        if (loading)
                          Text(
                            '$role',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Container(
                    color: Colors.grey[200],
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const RiwayatPage(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.home,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Riwayat Kos",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SyaratKetentuanPage(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.assignment,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Syarat dan ketentuan",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LayananPage(),
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.help_outline,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Layanan Bantuan",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfile(
                                        model: uData!,
                                        reload: true,
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: 25,
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Setting",
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              LayoutBuilder(
                                builder: (BuildContext context,
                                    BoxConstraints constraints) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    width: constraints.maxWidth,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _handleLogout();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.all(0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                            'Keluar',
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
              ],
            ),
    );
  }
}
