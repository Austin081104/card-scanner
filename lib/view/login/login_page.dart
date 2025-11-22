import 'package:card_sacnner_app/view/homescreen/homescreen_view.dart';
import 'package:card_sacnner_app/view/login/forgot_password.dart';
import 'package:card_sacnner_app/view/login/signup_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isLoading = false;

  // ✅ LOGIN FUNCTION
  Future<void> loginUser() async {
    try {
      setState(() => isLoading = true);

      // Firebase login
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('uid', FirebaseAuth.instance.currentUser!.uid);

      // SUCCESS
      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to Home
      Get.offAll(() => const HomescreenView());
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'user-not-found') {
        message = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format.';
      } else {
        message = e.message ?? 'Something went wrong.';
      }

      Get.snackbar(
        'Error',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('Login', style: TextStyle(fontSize: 30))],
                ),

                // Top image
                Image.asset('assets/onboarding/login.png', height: 300),
                const SizedBox(height: 10),

                // Email field
                TextFormField(
                  controller: emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your email';
                    } else if (!GetUtils.isEmail(val)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your Email',
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Password field
                TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please enter your password';
                    } else if (val.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter your Password',
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(), // placeholder for alignment
                    GestureDetector(
                      onTap: () => Get.to(() => const ForgotPasswordView()),
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Color(0xFF4FB0CE)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              loginUser();
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FB0CE),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // // OR divider
                // const Row(
                //   children: [
                //     Expanded(child: Divider(thickness: 1)),
                //     Padding(
                //       padding: EdgeInsets.symmetric(horizontal: 10),
                //       child: Text('Or', style: TextStyle(fontSize: 15)),
                //     ),
                //     Expanded(child: Divider(thickness: 1)),
                //   ],
                // ),
                // const SizedBox(height: 16),

                // // Facebook button
                // OutlinedButton.icon(
                //   style: OutlinedButton.styleFrom(
                //     minimumSize: const Size(double.infinity, 48),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   onPressed: () {},
                //   icon: const Icon(Icons.facebook, color: Colors.blue),
                //   label: const Text('Login with Facebook'),
                // ),
                // const SizedBox(height: 12),

                // // Google button
                // OutlinedButton.icon(
                //   style: OutlinedButton.styleFrom(
                //     minimumSize: const Size(double.infinity, 48),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   onPressed: () {},
                //   icon: const Icon(
                //     Icons.email_outlined,
                //     color: Colors.redAccent,
                //   ),
                //   label: const Text('Login with Google'),
                // ),
                // const SizedBox(height: 20),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () => Get.to(() => const SignUpPage()),
                      child: const Text(
                        'Sign up',
                        style: TextStyle(color: Color(0xFF4FB0CE)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
