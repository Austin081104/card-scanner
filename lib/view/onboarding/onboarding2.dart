import 'package:flutter/material.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset('assets/onboarding/page2.png'),
          const SizedBox(height: 30),
          Text(
            'Welcome to Business\nCard Scanner',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,

              shadows: [
                Shadow(
                  offset: const Offset(3, 3), // base drop shadow
                  blurRadius: 3,
                  color: Colors.grey.withOpacity(0.5),
                ),
                Shadow(
                  offset: const Offset(2, 2), // mid-layer shadow for depth
                  blurRadius: 2,
                  color: Colors.grey.withOpacity(0.3),
                ),
                Shadow(
                  offset: const Offset(1, 1), // top highlight edge
                  blurRadius: 1,
                  color: Colors.grey.withOpacity(0.2),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 10),
          const Text(
            'Scan Paper Business Cards and \nConvert them into actionable \nPhone Cantacts.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 25),
          ),

          Image.asset('assets/onboarding/bottom2.png'),
        ],
      ),
    );
  }
}
