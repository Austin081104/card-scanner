import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppbarWidget(
          title: 'Terms & Conditions',
          icon: Icons.description,
          leadingIcon: Icons.arrow_back,
          onLeadingIconTap: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('''
Welcome to Card Scanner App! Before using this app, please read these Terms & Conditions carefully.

1. **Acceptance of Terms**
By accessing or using this app, you agree to be bound by these terms.

2. **User Accounts**
You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.

3. **Data Usage**
The app stores your scanned card data locally and may use it for app functionalities. We do not share your data without your consent.

4. **Prohibited Activities**
You agree not to misuse the app or attempt to gain unauthorized access to any part of the app or other users’ data.

5. **Disclaimer**
The app is provided "as is" without warranties of any kind. We are not responsible for any data loss or damages.

6. **Changes to Terms**
We reserve the right to modify these terms at any time. Continued use of the app constitutes acceptance of the updated terms.

7. **Contact Us**
For any questions regarding these terms, please contact support@example.com.
''', style: GoogleFonts.poppins(fontSize: 14, height: 1.6)),
            const SizedBox(height: 30),
           
          ],
        ),
      ),
    );
  }
}
