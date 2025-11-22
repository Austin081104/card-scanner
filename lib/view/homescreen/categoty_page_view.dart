import 'dart:convert';
import 'dart:math';

import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryPageView extends StatefulWidget {
  const CategoryPageView({super.key});

  @override
  State<CategoryPageView> createState() => _CategoryPageViewState();
}

class _CategoryPageViewState extends State<CategoryPageView> {
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> cards = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 🔹 Ensures data is refreshed every time this page becomes visible
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCategories();
    await _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('savedCards') ?? [];
    setState(() {
      cards = data
          .map((e) => Map<String, dynamic>.from(json.decode(e)))
          .toList();
    });
  }

  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('categories') ?? [];
    setState(() {
      categories = data
          .map((e) => Map<String, dynamic>.from(json.decode(e)))
          .toList();
    });
  }

  Future<void> _saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = categories.map((e) => json.encode(e)).toList();
    await prefs.setStringList('categories', data);
  }

  void _addCategory(String name) async {
    final randomColor = _getRandomColor();
    final newCategory = {'name': name, 'color': randomColor.value};
    setState(() => categories.add(newCategory));
    await _saveCategories();
  }

  Color _getRandomColor() {
    const colors = [
      Colors.redAccent,
      Colors.orangeAccent,
      Colors.blue,
      Color(0xFF81C784), // Green
      Color(0xFFFF8A65), // Deep Orange
      Colors.brown,
      Color(0xFFF06292), // Pink
      Color(0xFFBA68C8), // Purple
    ];
    return colors[Random().nextInt(colors.length)];
  }

  void _deleteCategory(int index) async {
    setState(() => categories.removeAt(index));
    await _saveCategories();
  }

  void _showAddCategoryDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Category'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter category name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                _addCategory(controller.text.trim());
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // 🔹 Count how many cards belong to a given category
  int _getCardCountForCategory(String categoryName) {
    final count = cards
        .where((card) => card['category'] == categoryName)
        .length;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppbarWidget(title: 'Categories', icon: Icons.category_rounded),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: categories.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              if (index == categories.length) {
                return GestureDetector(
                  onTap: _showAddCategoryDialog,
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, size: 50, color: Colors.grey),
                    ),
                  ),
                );
              }

              final c = categories[index];
              final color = Color(c['color']);
              final cardCount = _getCardCountForCategory(c['name']);

              return Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: color.withOpacity(0.1),
                      child: Text(
                        c['name'][0].toUpperCase(),
                        style: TextStyle(
                          fontSize: 28,
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        Text(
                          c['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$cardCount cards',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        onSelected: (value) {
                          if (value == 'delete') _deleteCategory(index);
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
