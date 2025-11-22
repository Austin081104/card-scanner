import 'dart:convert';

class BusinessCardModel {
  String name;
  String position;
  String company;
  String mobile;
  String email;
  String website;
  String address;
  String imagePath;
  bool isFavorite;
  String? category; // ✅ New field for category name
  int? categoryColor; // ✅ Store color value (int)

  BusinessCardModel({
    this.name = '',
    this.position = '',
    this.company = '',
    this.mobile = '',
    this.email = '',
    this.website = '',
    this.address = '',
    this.imagePath = '',
    this.isFavorite = false,
    this.category,
    this.categoryColor,
  });

  factory BusinessCardModel.fromMap(Map<String, dynamic> map) {
    return BusinessCardModel(
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      company: map['company'] ?? '',
      mobile: map['mobile'] ?? '',
      email: map['email'] ?? '',
      website: map['website'] ?? '',
      address: map['address'] ?? '',
      imagePath: map['imagePath'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      category: map['category'],
      categoryColor: map['categoryColor'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'company': company,
      'mobile': mobile,
      'email': email,
      'website': website,
      'address': address,
      'imagePath': imagePath,
      'isFavorite': isFavorite,
      'category': category,
      'categoryColor': categoryColor,
    };
  }

  factory BusinessCardModel.fromJson(String source) =>
      BusinessCardModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}
