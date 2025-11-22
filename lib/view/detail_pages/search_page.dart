import 'dart:io';

import 'package:card_sacnner_app/modal/cardmodal.dart';
import 'package:card_sacnner_app/view/detail_pages/card_detail_page.dart';
import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<BusinessCardModel> allCards = [];
  List<BusinessCardModel> filteredCards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('savedCards') ?? [];
    setState(() {
      allCards = list.map((e) => BusinessCardModel.fromJson(e)).toList();
      filteredCards = List.from(allCards);
    });
  }

  void _filterCards(String query) {
    final lower = query.toLowerCase().trim();
    setState(() {
      if (lower.isEmpty) {
        filteredCards = List.from(allCards);
      } else {
        filteredCards = allCards.where((card) {
          return (card.name.toLowerCase().contains(lower)) ||
              (card.company.toLowerCase().contains(lower)) ||
              (card.email.toLowerCase().contains(lower)) ||
              (card.mobile.toLowerCase().contains(lower)) ||
              (card.website.toLowerCase().contains(lower));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppbarWidget(
          title: 'Search Card',
          leadingIcon: Icons.arrow_back,
          onLeadingIconTap: () => Get.back(),
        ),
      ),

      //  backgroundColor: const Color(0xFF2575FC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ✅ Search field inside body
            TextField(
              controller: _searchController,
              onChanged: _filterCards,
              style: GoogleFonts.poppins(),
              decoration: InputDecoration(
                hintText: 'Search by name, company, or email...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ✅ Results list
            Expanded(
              child: filteredCards.isEmpty
                  ? Center(
                      child: Text(
                        'No matching results found.',
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredCards.length,
                      itemBuilder: (context, index) {
                        final card = filteredCards[index];
                        final hasImage =
                            card.imagePath.isNotEmpty &&
                            File(card.imagePath).existsSync();

                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            leading: hasImage
                                ? CircleAvatar(
                                    backgroundImage: FileImage(
                                      File(card.imagePath),
                                    ),
                                    radius: 25,
                                  )
                                : const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    child: Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                            title: Text(
                              card.name.isEmpty ? 'Unknown' : card.name,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              '${card.company}\n${card.email}',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                            isThreeLine: true,
                            onTap: () {
                              Get.to(
                                () => CardDetailPage(
                                  name: card.name,
                                  company: card.company,
                                  email: card.email,
                                  mobile: card.mobile,
                                  address: card.address,
                                  website: card.website,
                                  position: card.position,
                                  imagePath: card.imagePath,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
