import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/user_model.dart';
import 'package:kos_tes/view/screen/admin/side_bar.dart';

class AdminPage extends StatefulWidget {
  final VoidCallback signOut;
  const AdminPage({super.key, required this.signOut});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var loading = false;
  UsersModel? uData;
  String? id = "", email = "", username = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      username = preferences.getString("username");
    });
  }

  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  Future<void> userData() async {
    setState(() {
      loading = true;
    });

    await getPref();

    final response = await http.get(
        Uri.parse('https://datakos1.000webhostapp.com/lihatusers.php?id=$id'));
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
    return Scaffold(
      drawer:uData != null
  ? SideBarAdmin(
      model: uData!,
      reload: true,
    ) : const SizedBox(),
      appBar: AppBar(
        title: const Text('Halaman Admin'),
        actions: [
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Admin Page'),
      ),
    );
  }
}
