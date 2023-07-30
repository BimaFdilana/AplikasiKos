import 'package:flutter/material.dart';
import 'package:kos_tes/model/user_model.dart';
import 'package:kos_tes/view/screen/admin/kos_page_admin.dart';
import 'package:kos_tes/view/screen/admin/user_page_admin.dart';

class SideBarAdmin extends StatefulWidget {
  final UsersModel model;
  final bool reload;
  const SideBarAdmin({super.key, required this.model, required this.reload});

  @override
  State<SideBarAdmin> createState() => _SideBarAdminState();
}

class _SideBarAdminState extends State<SideBarAdmin> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.model.username),
            accountEmail: Text(widget.model.email),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                    'https://datakos1.000webhostapp.com/upload/${widget.model.image}'),
              ),
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_search_rounded),
            title: const Text('User Akun'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const KosPageAdmin(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: const Text('Item Kos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserAdminPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
