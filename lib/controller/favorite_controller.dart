// import 'dart:convert';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:card_sacnner_app/modal/cardmodal.dart';

// class FavoriteController extends GetxController {
//   RxList<BusinessCardModel> favCards = <BusinessCardModel>[].obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadFavorites();
//   }

//   /// Load favorite cards from SharedPreferences
//   Future<void> loadFavorites() async {
//     final prefs = await SharedPreferences.getInstance();
//     final list = prefs.getStringList('savedCards') ?? [];

//     final allCards = list.map((e) {
//       try {
//         return BusinessCardModel.fromJson(e);
//       } catch (_) {
//         return BusinessCardModel(
//           name: 'Invalid Card',
//           company: '',
//           email: '',
//           mobile: '',
//           address: '',
//           website: '',
//           position: '',
//           imagePath: '',
//           isFavorite: false,
//         );
//       }
//     }).toList();

//     favCards.value = allCards.where((c) => c.isFavorite).toList();
//   }

//   /// Reload favorites (external trigger)
//   Future<void> refreshFavorites() async => await loadFavorites();
// }
