import 'dart:convert';
import 'dart:io';

import 'package:card_sacnner_app/modal/cardmodal.dart';
import 'package:card_sacnner_app/view/detail_pages/card_detail_page.dart';
import 'package:card_sacnner_app/view/detail_pages/edit_card_page.dart';
import 'package:card_sacnner_app/view/detail_pages/search_page.dart';
import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageView extends StatefulWidget {
  final VoidCallback? onFavoriteChanged; // 👈 Add this

  const HomePageView({super.key, this.onFavoriteChanged});

  @override
  State<HomePageView> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePageView> {
  List<BusinessCardModel> cards = [];
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
    _loadCategories();
    _removeDeletedCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCards();
    _loadCategories();
    _removeDeletedCategories();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('savedCards') ?? [];
    setState(() {
      cards = list.map((e) => BusinessCardModel.fromJson(e)).toList();
    });
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('categories') ?? [];
    setState(() {
      categories = list
          .map((e) => Map<String, dynamic>.from(json.decode(e)))
          .toList();
    });
  }

  Future<void> _shareCard(BusinessCardModel card) async {
    // Prepare formatted text
    final details =
        '''
           Name: ${card.name.isNotEmpty ? card.name : "No Name"}
           Company: ${card.company.isNotEmpty ? card.company : "Not Provided"}
           Position: ${card.position.isNotEmpty ? card.position : "Not Provided"}
           Mobile: ${card.mobile.isNotEmpty ? card.mobile : "Not Provided"}
           Email: ${card.email.isNotEmpty ? card.email : "Not Provided"}
           Website: ${card.website.isNotEmpty ? card.website : "Not Provided"}
           Address: ${card.address.isNotEmpty ? card.address : "Not Provided"}
''';

    if (card.imagePath.isNotEmpty && File(card.imagePath).existsSync()) {
      // Share with image
      await Share.shareXFiles([XFile(card.imagePath)], text: details);
    } else {
      // Share text only
      await Share.share(details);
    }
  }

  Future<void> _deleteCard(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('savedCards') ?? [];
    list.removeAt(index);
    await prefs.setStringList('savedCards', list);
    await _loadCards();
    widget.onFavoriteChanged?.call(); // refresh fav page
  }

  // Future<void> _clearAll() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove('savedCards');
  //   setState(() => cards.clear());
  //   widget.onFavoriteChanged?.call(); // refresh fav page
  // }
  Future<void> _saveCards() async {
    final prefs = await SharedPreferences.getInstance();
    final list = cards.map((e) => e.toJson()).toList();
    await prefs.setStringList('savedCards', list);
  }

  Future<void> _toggleFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('savedCards') ?? [];
    final card = cards[index];
    card.isFavorite = !card.isFavorite;

    list[index] = card.toJson();
    await prefs.setStringList('savedCards', list);

    setState(() {});
    widget.onFavoriteChanged?.call(); // 🔥 notify favorite page
  }

  Future<void> _assignCategory(int index) async {
    await _loadCategories();
    if (categories.isEmpty) {
      _showNoCategoryDialog();
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Assign Category'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, i) {
              final c = categories[i];
              final color = Color(c['color']);
              return ListTile(
                leading: CircleAvatar(backgroundColor: color),
                title: Text(c['name']),
                onTap: () async {
                  cards[index].category = c['name'];
                  cards[index].categoryColor = color.value;
                  await _saveCards();
                  setState(() {});
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _removeCategory(int index) async {
    cards[index].category = null;
    cards[index].categoryColor = null;
    await _saveCards();
    setState(() {});
  }

  void _showNoCategoryDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('No Categories Found'),
        content: const Text(
          'Please create a category first in the Category tab.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _removeDeletedCategories() async {
    final prefs = await SharedPreferences.getInstance();

    // Get all existing categories
    final categoryList = prefs.getStringList('categories') ?? [];
    final validCategories = categoryList
        .map((e) => Map<String, dynamic>.from(json.decode(e))['name'])
        .toList();

    bool updated = false;

    for (var card in cards) {
      if (card.category != null && !validCategories.contains(card.category)) {
        card.category = null;
        card.categoryColor = null;
        updated = true;
      }
    }

    if (updated) {
      await _saveCards();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppbarWidget(
          title: 'CardScanner',
          icon: Icons.search,
          onIconTap: () {
            Get.to(() => const SearchPage());
          },
        ),
      ),

      body: cards.isEmpty
          ? Center(
              child: Text(
                'No saved cards yet.\nTap the scan button below to add one!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 16),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: cards.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // two cards per row

                childAspectRatio: 0.68, // adjust for height/width balance
              ),
              itemBuilder: (context, index) {
                final c = cards[index];
                final hasImage =
                    c.imagePath.isNotEmpty && File(c.imagePath).existsSync();
                final color = c.categoryColor != null
                    ? Color(c.categoryColor!)
                    : Colors.grey.shade300;
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // top color strip
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 8,
                            right: 3,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // image + menu row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  hasImage
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: GestureDetector(
                                            onTap: () => Get.to(
                                              () => CardDetailPage(
                                                address: c.address,
                                                company: c.company,
                                                email: c.email,
                                                imagePath: c.imagePath,
                                                mobile: c.mobile,
                                                name: c.name,
                                                position: c.position,
                                                website: c.website,
                                              ),
                                            ),
                                            child: Image.file(
                                              File(c.imagePath),
                                              width: 120,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () => Get.to(
                                            () => CardDetailPage(
                                              address: c.address,
                                              company: c.company,
                                              email: c.email,
                                              imagePath: c.imagePath,
                                              mobile: c.mobile,
                                              name: c.name,
                                              position: c.position,
                                              website: c.website,
                                            ),
                                          ),
                                          child: Container(
                                            width: 120,
                                            height: 70,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.image,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert),
                                    onSelected: (value) {
                                      switch (value) {
                                        case 'add_category':
                                          _assignCategory(index);
                                          break;
                                        case 'remove_category':
                                          _removeCategory(index);
                                          break;
                                        case 'Delete_card':
                                          _deleteCard(index);
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'add_category',
                                        child: Text('Add to Category'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'remove_category',
                                        child: Text('Remove from Category'),
                                      ),
                                      const PopupMenuItem(
                                        value: 'Delete_card',
                                        child: Text('Delete Card'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                c.name.isEmpty
                                    ? 'Name: Unknown'
                                    : 'Name: ${c.name}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Email: ${c.email}\nPhone: ${c.mobile}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                              const Spacer(),
                              if (c.category != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    c.category!,
                                    style: TextStyle(
                                      color: color,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 6),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(12),
                                    ),

                                    child: IconButton(
                                      icon: Icon(
                                        c.isFavorite
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        color: c.isFavorite
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                      onPressed: () => _toggleFavorite(index),
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.share,
                                        color: Colors.black,
                                      ),
                                      onPressed: () => _shareCard(c),
                                    ),
                                  ),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        Get.to(
                                          () => EditCardPage(
                                            card: c,
                                            index: index,
                                            onSave: (updatedCard, i) async {
                                              final prefs =
                                                  await SharedPreferences.getInstance();
                                              final list =
                                                  prefs.getStringList(
                                                    'savedCards',
                                                  ) ??
                                                  [];
                                              cards[i] = updatedCard;
                                              list[i] = updatedCard.toJson();
                                              await prefs.setStringList(
                                                'savedCards',
                                                list,
                                              );
                                              setState(() {});
                                              widget.onFavoriteChanged?.call();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
