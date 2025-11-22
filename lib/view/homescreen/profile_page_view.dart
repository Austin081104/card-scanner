import 'package:card_sacnner_app/view/detail_pages/terms_and_condition_page.dart';
import 'package:card_sacnner_app/view/login/login_page.dart';
import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageView extends StatefulWidget {
  const ProfilePageView({super.key});

  @override
  State<ProfilePageView> createState() => _ProfilePageViewState();
}

class _ProfilePageViewState extends State<ProfilePageView> {
  double _rating = 0; // user’s selected rating

  // Show Rating Dialog
  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double tempRating = _rating;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Rate Us',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'How was your experience?',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),

              // Star Rating Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < tempRating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setState(() => _rating = index + 1.0);
                      Navigator.pop(context);
                      _showThankYouDialog();
                    },
                  );
                }),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  // Thank You Dialog after rating
  void _showThankYouDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Thank You!'),
        content: Text(
          'You rated $_rating stars.\nWe appreciate your feedback!',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // Show logout confirmation dialog
  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog

              // Sign out from Firebase
              await FirebaseAuth.instance.signOut();

              // Clear login SharedPreferences
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('isLoggedIn');

              // Navigate to Login page
              Get.offAll(() => const LoginPage());
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Show delete account confirmation dialog
  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog

              try {
                // Delete Firebase user
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.delete(); // Deletes Firebase account
                }

                // Clear login SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');

                // Navigate to login page
                Get.offAll(() => const LoginPage());

                Get.snackbar(
                  'Deleted',
                  'Your account has been deleted.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } on FirebaseAuthException catch (e) {
                // If the user needs to reauthenticate
                if (e.code == 'requires-recent-login') {
                  Get.snackbar(
                    'Error',
                    'Please log out and log in again before deleting your account.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    e.message ?? 'Something went wrong.',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  } // Inside your ProfilePageView State class

  // Show Change Password Dialog
  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Change Password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Enter current password';
                  if (val.length < 6) return 'Password too short';
                  return null;
                },
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Enter new password';
                  if (val.length < 6) return 'Password too short';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;

              Navigator.pop(context); // Close dialog
              final user = FirebaseAuth.instance.currentUser;
              if (user != null && user.email != null) {
                final cred = EmailAuthProvider.credential(
                  email: user.email!,
                  password: currentPasswordController.text.trim(),
                );

                try {
                  // Re-authenticate user
                  await user.reauthenticateWithCredential(cred);

                  // Update password
                  await user.updatePassword(newPasswordController.text.trim());

                  Get.snackbar(
                    'Success',
                    'Password changed successfully',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'wrong-password') {
                    Get.snackbar(
                      'Error',
                      'Current password is incorrect',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  } else {
                    Get.snackbar(
                      'Error',
                      e.message ?? 'Something went wrong',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                    );
                  }
                }
              }
            },
            child: const Text('Change', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppbarWidget(title: 'Profile', icon: Icons.person_2),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 👤 Profile Card
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 20,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        backgroundColor: Color(0xFF6A11CB),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Austin Chettiar',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Flutter Developer Intern',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 226, 224, 224),
                        child: Icon(Icons.qr_code, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // ⚙️ Settings / Options
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildDivider(),
                    _buildListTile(
                      Icons.pages,
                      'Terms & Conditions',
                      onTap: () => Get.to(() => const TermsConditionsPage()),
                    ),
                    _buildDivider(),
                    _buildListTile(
                      Icons.star_border_outlined,
                      'Rate Us',
                      onTap: _showRatingDialog,
                    ),
                    _buildDivider(),
                    _buildListTile(
                      Icons.lock_reset,
                      'Change Password',
                      onTap: _showChangePasswordDialog,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ⚠️ Account Section
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  children: [
                    _buildListTile(
                      Icons.delete,
                      'Delete Account',
                      color: Colors.red,
                      onTap: _confirmDeleteAccount,
                    ),
                    _buildDivider(),
                    _buildListTile(
                      Icons.logout,
                      'Logout',
                      color: Colors.red,
                      onTap: _confirmLogout,
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

  // 📦 Helper widget: standard ListTile
  Widget _buildListTile(
    IconData icon,
    String title, {
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? Colors.black),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.black,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.black),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, indent: 15, endIndent: 15);
}
