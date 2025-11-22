import 'dart:io';

import 'package:card_sacnner_app/modal/cardmodal.dart';
import 'package:card_sacnner_app/view/detail_pages/card_detail_page.dart';
import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePageView extends StatefulWidget {
  const FavoritePageView({super.key});

  @override
  FavoritePageViewState createState() => FavoritePageViewState();
}

class FavoritePageViewState extends State<FavoritePageView> {
  List<BusinessCardModel> favCards = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  /// Loads all favorite cards from SharedPreferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('savedCards') ?? [];
    final allCards = list.map((e) => BusinessCardModel.fromJson(e)).toList();

    setState(() {
      favCards = allCards.where((c) => c.isFavorite).toList();
    });
  }

  /// 👇 Public method that can be called from outside using a GlobalKey
  Future<void> refreshFavorites() async {
    await loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppbarWidget(title: 'Favorites', icon: Icons.favorite),
      ),
      body: favCards.isEmpty
          ? const Center(child: Text('No favorites yet! ❤️'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favCards.length,
              itemBuilder: (context, index) {
                final c = favCards[index];
                final hasImage =
                    c.imagePath.isNotEmpty && File(c.imagePath).existsSync();

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 10,
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 8,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 🖼 Profile Image or Initial
                        hasImage
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(
                                  File(c.imagePath),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF6A11CB),
                                      Color(0xFF2575FC),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    c.name.isNotEmpty
                                        ? c.name[0].toUpperCase()
                                        : '?',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                        const SizedBox(width: 12),

                        // 🧾 Card Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name.isNotEmpty ? c.name : 'Unnamed Contact',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                c.company.isNotEmpty ? c.company : 'Company: —',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    size: 15,
                                    color: Colors.deepPurple,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      c.mobile.isNotEmpty
                                          ? c.mobile
                                          : 'No phone number',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    size: 15,
                                    color: Colors.deepPurple,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      c.email.isNotEmpty ? c.email : 'No email',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Get.to(
                              () => CardDetailPage(
                                name: c.name,
                                company: c.company,
                                email: c.email,
                                mobile: c.mobile,
                                address: c.address,
                                website: c.website,
                                position: c.position,
                                imagePath: c.imagePath,
                              ),
                            );
                          },
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
