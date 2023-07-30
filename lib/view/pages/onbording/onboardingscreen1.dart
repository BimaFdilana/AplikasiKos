// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:kos_tes/model/onboard_model.dart';
import 'package:kos_tes/view/auth/login.dart';
import 'package:kos_tes/view/auth/pilih_regist.dart';
import 'package:kos_tes/view/pages/constractor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnbScreen1 extends StatefulWidget {
  const OnbScreen1({super.key});
  @override
  State<OnbScreen1> createState() => _OnbScreen1State();
}

class _OnbScreen1State extends State<OnbScreen1> {
  int currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  storeOnBoardInfo() async {
    int isViewed =0;
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("onBoard", isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          currentIndex % 2 == 0 ? MyColors.kputih : MyColors.khijau2,
      appBar: AppBar(
        backgroundColor:
            currentIndex % 2 == 0 ? MyColors.kputih : MyColors.khijau2,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              await storeOnBoardInfo();
              storeOnBoardInfo();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
            },
            child: Text(
              'Lewati',
              style: TextStyle(
                color: currentIndex % 2 == 0 ? MyColors.khitam : MyColors.kputih,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(screens[index].img),
                  SizedBox(
                    height: 10.0,
                    child: ListView.builder(
                      itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3.0),
                              width: currentIndex == index ? 25.0 : 8.0,
                              height: 8.0,
                              decoration: BoxDecoration(
                                  color: currentIndex == index ? MyColors.khijau0 : MyColors.khijau4,
                                  borderRadius: BorderRadius.circular(10.0)),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Text(
                    screens[index].text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      color: currentIndex % 2 == 0 ? MyColors.khitam : MyColors.kputih,
                    ),
                  ),
                  Text(
                    screens[index].desc,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: currentIndex % 2 == 0 ? MyColors.khitam : MyColors.kputih,
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      if (index == screens.length - 1) {
                        await storeOnBoardInfo();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const PilihRegist()));
                      }
                      pageController.nextPage(
                          duration: const Duration(microseconds: 300),
                          curve: Curves.bounceIn);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: currentIndex % 2 == 0 ? MyColors.khijau2 : MyColors.kputih,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Lanjut',
                            style: TextStyle(
                              fontSize: 16.0,
                              color:currentIndex % 2 == 0 ? MyColors.kputih : MyColors.khijau1,
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Icon(
                            Icons.arrow_forward_sharp,
                            color: currentIndex % 2 == 0 ? MyColors.kputih : MyColors.khijau1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
