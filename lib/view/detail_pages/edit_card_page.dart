import 'dart:io';

import 'package:card_sacnner_app/modal/cardmodal.dart';
import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditCardPage extends StatefulWidget {
  final BusinessCardModel card;
  final int index;
  final Function(BusinessCardModel, int) onSave;

  const EditCardPage({
    super.key,
    required this.card,
    required this.index,
    required this.onSave,
  });

  @override
  State<EditCardPage> createState() => _EditCardPageState();
}

class _EditCardPageState extends State<EditCardPage> {
  late TextEditingController nameController;
  late TextEditingController companyController;
  late TextEditingController positionController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController websiteController;
  late TextEditingController addressController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.card.name);
    companyController = TextEditingController(text: widget.card.company);
    positionController = TextEditingController(text: widget.card.position);
    mobileController = TextEditingController(text: widget.card.mobile);
    emailController = TextEditingController(text: widget.card.email);
    websiteController = TextEditingController(text: widget.card.website);
    addressController = TextEditingController(text: widget.card.address);
    imagePath = widget.card.imagePath;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imagePath = picked.path;
      });
    }
  }

  void _saveChanges() {
    // ✅ Clean up mobile number (remove spaces/dashes)
    final cleanedMobile = mobileController.text.replaceAll(
      RegExp(r'[^0-9+]'),
      '',
    );

    final updatedCard = BusinessCardModel(
      name: nameController.text.trim(),
      company: companyController.text.trim(),
      position: positionController.text.trim(),
      mobile: cleanedMobile,
      email: emailController.text.trim(),
      website: websiteController.text.trim(),
      address: addressController.text.trim(),
      imagePath: imagePath ?? '',
      isFavorite: widget.card.isFavorite,
      category: widget.card.category,
      categoryColor: widget.card.categoryColor,
    );

    widget.onSave(updatedCard, widget.index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppbarWidget(
          title: 'Edit Card',
          leadingIcon: Icons.arrow_back,
          onLeadingIconTap: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: imagePath != null && File(imagePath!).existsSync()
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(imagePath!),
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.camera_alt, size: 40),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            _buildTextField(nameController, 'Name'),
            _buildTextField(companyController, 'Company'),
            _buildTextField(positionController, 'Position'),
            _buildTextField(
              mobileController,
              'Mobile',
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              emailController,
              'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(websiteController, 'Website'),
            _buildTextField(addressController, 'Address', maxLines: 2),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: const Icon(Icons.save),
              label: const Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: Colors.amber,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
