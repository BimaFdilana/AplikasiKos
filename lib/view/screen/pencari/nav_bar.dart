import 'package:flutter/material.dart';
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:kos_tes/view/screen/home_page.dart';
import 'package:kos_tes/view/screen/notifikasi_kos.dart';
import 'package:kos_tes/view/screen/pencari/pencari_kos.dart';
import 'package:kos_tes/view/screen/profile/profile.dart';

import '../../auth/login.dart';

class NavBar1 extends StatefulWidget {
  final VoidCallback signOut;
  const NavBar1(this.signOut, {Key? key}) : super(key: key);

  @override
  State<NavBar1> createState() => _NavBar1State();
}

class _NavBar1State extends State<NavBar1> {
  TabController? tabController;
  int currentIndex = 0;

  List<Widget> pakes = [];

  @override
  void initState() {
    super.initState();
    pakes = [
      const HomePage(),
      const PencariKos(),
      const NotifikasiKos(),
      Profile(signOut: _handleLogout)
    ];
  }

  void _handleLogout() {
    widget.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  void onTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: pakes[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTab,
          currentIndex: currentIndex,
          type: BottomNavigationBarType.shifting,
          selectedItemColor: MyColors.khijau1,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_rounded),
              label: "Maps",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_rounded),
              label: "Notif",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_rounded),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
