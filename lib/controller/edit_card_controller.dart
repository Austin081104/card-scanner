// import 'dart:io';
// import 'package:card_sacnner_app/modal/cardmodal.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class EditCardController extends GetxController {
//   late TextEditingController nameController;
//   late TextEditingController companyController;
//   late TextEditingController positionController;
//   late TextEditingController mobileController;
//   late TextEditingController emailController;
//   late TextEditingController websiteController;
//   late TextEditingController addressController;

//   final imagePath = ''.obs;

//   final BusinessCardModel card;
//   final int index;
//   final Function(BusinessCardModel, int) onSave;

//   EditCardController({
//     required this.card,
//     required this.index,
//     required this.onSave,
//   });

//   @override
//   void onInit() {
//     nameController = TextEditingController(text: card.name);
//     companyController = TextEditingController(text: card.company);
//     positionController = TextEditingController(text: card.position);
//     mobileController = TextEditingController(text: card.mobile);
//     emailController = TextEditingController(text: card.email);
//     websiteController = TextEditingController(text: card.website);
//     addressController = TextEditingController(text: card.address);
//     imagePath.value = card.imagePath;
//     super.onInit();
//   }

//   Future<void> pickImage() async {
//     final picker = ImagePicker();
//     final picked = await picker.pickImage(source: ImageSource.gallery);
//     if (picked != null) {
//       imagePath.value = picked.path;
//     }
//   }

//   void saveChanges() {
//     final cleanedMobile =
//         mobileController.text.replaceAll(RegExp(r'[^0-9+]'), '');

//     final updatedCard = BusinessCardModel(
//       name: nameController.text.trim(),
//       company: companyController.text.trim(),
//       position: positionController.text.trim(),
//       mobile: cleanedMobile,
//       email: emailController.text.trim(),
//       website: websiteController.text.trim(),
//       address: addressController.text.trim(),
//       imagePath: imagePath.value,
//       isFavorite: card.isFavorite,
//       category: card.category,
//       categoryColor: card.categoryColor,
//     );

//     onSave(updatedCard, index);
//     Get.back();
//   }

//   @override
//   void onClose() {
//     nameController.dispose();
//     companyController.dispose();
//     positionController.dispose();
//     mobileController.dispose();
//     emailController.dispose();
//     websiteController.dispose();
//     addressController.dispose();
//     super.onClose();
//   }
// }
