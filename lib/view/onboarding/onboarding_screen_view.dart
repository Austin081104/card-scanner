import 'package:card_sacnner_app/view/login/login_page.dart';
import 'package:card_sacnner_app/view/onboarding/onboarding1.dart';
import 'package:card_sacnner_app/view/onboarding/onboarding2.dart';
import 'package:card_sacnner_app/view/onboarding/onboarding3.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreenView extends StatefulWidget {
  const OnboardingScreenView({super.key});

  @override
  State<OnboardingScreenView> createState() => _OnboardingScreenViewState();
}

class _OnboardingScreenViewState extends State<OnboardingScreenView> {
  final controller = PageController();
  bool isLastpage = false;
  // Shared refernce for Onboarding
  // writedata() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setBool('dashboardScreen', true);
  //   setState(() {});
  // }

  // getdata() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? seen = prefs.getBool('dashboardScreen');

  //   // If already seen → skip onboarding
  //   if (seen == true) {
  //     Get.offAll( ()=> HomescreenView());
  //   }
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   getdata();
  //   super.initState();
  // }
  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }
Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('onboardingSeen', true);

    Get.off(() => const LoginPage());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          onPageChanged: (index) {
            setState(() {
              isLastpage = index == 2;
            });
          },
          controller: controller,
          children: const [Onboarding1(), Onboarding2(), Onboarding3()],
        ),
      ),

      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                controller.jumpToPage(2);
              },
              child: const Text(
                'SKIP',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF45a2c6),
                ),
              ),
            ),
            SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: const WormEffect(activeDotColor: Color(0xFF45a2c6)),
              onDotClicked: (index) {
                controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              },
            ),
            TextButton(
              onPressed: () {
                if (isLastpage) {
                  finishOnboarding();
                } else {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: Text(
                isLastpage ? 'Start' : 'Next',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF45a2c6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
