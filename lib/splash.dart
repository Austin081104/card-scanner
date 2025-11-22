import 'dart:async';

import 'package:card_sacnner_app/view/homescreen/homescreen_view.dart';
import 'package:card_sacnner_app/view/login/login_page.dart';
import 'package:card_sacnner_app/view/onboarding/onboarding_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // Timer(const Duration(seconds: 3), () {
    //   Get.off(() => const OnboardingScreenView());
    // });
    super.initState();
    checkFlow();
  }

  void checkFlow() async {
    final prefs = await SharedPreferences.getInstance();

    bool onboardingSeen = prefs.getBool('onboardingSeen') ?? false;
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    await Future.delayed(const Duration(seconds: 3));

    if (!onboardingSeen) {
      Get.off(() => const OnboardingScreenView());
    } else {
      if (isLoggedIn) {
        Get.off(() => const HomescreenView());
      } else {
        Get.off(() => const LoginPage());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 0.8,
            stops: [0.4, 1.0],
            colors: [Color(0xFF54b2cf), Color(0xFF2687bb)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                child: Container(
                  height: 140,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const RadialGradient(
                      colors: [Color(0xFF45a2c6), Color(0xFF2182b9)],
                    ),
                    image: const DecorationImage(
                      image: AssetImage('assets/splash/frame.png'),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Business',
                style: TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(3, 3), // base drop shadow
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Shadow(
                      offset: const Offset(2, 2), // mid-layer shadow for depth
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Shadow(
                      offset: const Offset(1, 1), // top highlight edge
                      blurRadius: 1,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),

              Text(
                'Card Scanner',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: const Offset(3, 3), // base drop shadow
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.5),
                    ),
                    Shadow(
                      offset: const Offset(2, 2), // mid-layer shadow for depth
                      blurRadius: 2,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Shadow(
                      offset: const Offset(1, 1), // top highlight edge
                      blurRadius: 1,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
