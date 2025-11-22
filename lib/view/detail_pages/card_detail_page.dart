import 'dart:io';

import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class CardDetailPage extends StatelessWidget {
  final String name;
  final String company;
  final String email;
  final String mobile;
  final String address;
  final String website;
  final String position;
  final String imagePath;

  const CardDetailPage({
    super.key,
    required this.name,
    required this.company,
    required this.email,
    required this.mobile,
    required this.address,
    required this.website,
    required this.position,
    required this.imagePath,
  });

  // ✅ Unified and Safe Launcher (handles phone, email, website)
  Future<void> _launchUrl(String input) async {
    try {
      String url = input.trim();
      Uri uri;

      // Handle phone number (with or without tel:)
      if (url.startsWith('tel:')) {
        uri = Uri.parse(url);
      } else if (RegExp(r'^[0-9+ ]+$').hasMatch(url)) {
        // Clean up number and prepend tel:
        final cleaned = url.replaceAll(RegExp(r'[^0-9+]'), '');
        uri = Uri(scheme: 'tel', path: cleaned);
      }
      // Handle email address
      else if (url.contains('@')) {
        uri = Uri(scheme: 'mailto', path: url);
      }
      // Handle websites (add https if missing)
      else {
        if (!url.startsWith('http')) {
          url = 'https://$url';
        }
        uri = Uri.parse(url);
      }

      // Try launching
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar(
          'Launch Error',
          'Could not open $url',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Invalid or unsupported link',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = imagePath.isNotEmpty && File(imagePath).existsSync();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppbarWidget(
          title: 'Card Details',
          leadingIcon: Icons.arrow_back,
          onLeadingIconTap: () => Get.back(),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🖼️ Profile / Card Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: hasImage
                  ? Image.file(
                      File(imagePath),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.deepPurple.shade100,
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ),
                    ),
            ),

            const SizedBox(height: 16),

            // 👤 Name & Position
            Text(
              name.isNotEmpty ? name : 'Unknown Name',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              position.isNotEmpty ? position : 'No Position',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),

            const Divider(height: 30, thickness: 1),

            // 🏢 Company
            _buildInfoTile(Icons.business, 'Company', company),

            // 📞 Mobile (tap to call)
            _buildInfoTile(
              Icons.phone,
              'Mobile',
              mobile,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                if (mobile.isNotEmpty) {
                  _launchUrl(mobile);
                }
              },
            ),

            // 📍 Address
            _buildInfoTile(Icons.location_on, 'Address', address),

            // 📧 Email (tap to send mail)
            _buildInfoTile(
              Icons.email,
              'Email',
              email,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                if (email.isNotEmpty) {
                  _launchUrl(email);
                }
              },
            ),

            // 🌐 Website (tap to open site)
            _buildInfoTile(
              Icons.language,
              'Website',
              website,
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                if (website.isNotEmpty) {
                  _launchUrl(website);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Reusable Info Tile Widget
  Widget _buildInfoTile(
    IconData icon,
    String title,
    String value, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.deepPurple),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          value.isNotEmpty ? value : 'Not available',
          style: const TextStyle(fontSize: 14),
        ),
        trailing: trailing,
      ),
    );
  }
}
