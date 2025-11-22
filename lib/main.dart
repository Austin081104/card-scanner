import 'package:card_sacnner_app/splash.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // final prefs = await SharedPreferences.getInstance();
  // final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
     home: const Splash(),
    );
  }
}
