import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kos_tes/view/auth/pilih_regist.dart';
import 'package:kos_tes/view/pages/onbording/onboardingscreen1.dart';
import 'package:shared_preferences/shared_preferences.dart';


int? isViewed;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  isViewed = pref.getInt('onBoard');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:isViewed !=0 ? const OnbScreen1() : const PilihRegist(),
    );
  }
}