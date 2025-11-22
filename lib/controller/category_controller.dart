import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryController extends GetxController {
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> cards = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await loadCategories();
    await loadCards();
  }

  Future<void> loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('savedCards') ?? [];
    cards.value = data.map((e) => Map<String, dynamic>.from(json.decode(e))).toList();
  }

  Future<void> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('categories') ?? [];
    categories.value = data.map((e) => Map<String, dynamic>.from(json.decode(e))).toList();
  }

  Future<void> saveCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = categories.map((e) => json.encode(e)).toList();
    await prefs.setStringList('categories', data);
  }

  void addCategory(String name) async {
    final randomColor = _getRandomColor();
    final newCategory = {'name': name, 'color': randomColor.value};
    categories.add(newCategory);
    await saveCategories();
  }

  void deleteCategory(int index) async {
    categories.removeAt(index);
    await saveCategories();
  }

  Color _getRandomColor() {
    const colors = [
      Color(0xFFD32F2F), // dark red
      Color(0xFFF57C00), // dark orange
      Color(0xFF1976D2), // blue
      Color(0xFF388E3C), // dark green
      Color(0xFF6A1B9A), // purple
      Color(0xFF5D4037), // brown
      Color(0xFFC2185B), // deep pink
      Color(0xFF512DA8), // indigo
    ];
    return colors[Random().nextInt(colors.length)];
  }

  int getCardCountForCategory(String categoryName) {
    return cards.where((card) => card['category'] == categoryName).length;
  }
}
