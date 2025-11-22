import 'dart:io';

import 'package:card_sacnner_app/modal/cardmodal.dart';
import 'package:card_sacnner_app/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_doc_scanner/flutter_doc_scanner.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessCardScannerPage extends StatefulWidget {
  const BusinessCardScannerPage({super.key});

  @override
  State<BusinessCardScannerPage> createState() =>
      _BusinessCardScannerPageState();
}

class _BusinessCardScannerPageState extends State<BusinessCardScannerPage> {
  File? _scannedImage;

  final name = TextEditingController();
  final position = TextEditingController();
  final company = TextEditingController();
  final mobile = TextEditingController();
  final email = TextEditingController();
  final website = TextEditingController();
  final address = TextEditingController();

  Future<void> scanDocument() async {
    try {
      dynamic result = await FlutterDocScanner().getScanDocuments(page: 1);

      if (result == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('No document scanned.')));
        return;
      }

      String? scannedPath;
      if (result is List && result.isNotEmpty) {
        scannedPath = result.first;
      } else if (result is Map && result['path'] != null) {
        scannedPath = result['path'];
      } else if (result is Map && result['pdfUri'] != null) {
        final pdfUri = result['pdfUri'].toString().replaceFirst('file://', '');
        scannedPath = await _convertPdfToImage(pdfUri);
      } else if (result is String &&
          (result.endsWith('.png') || result.endsWith('.jpg'))) {
        scannedPath = result;
      }

      if (scannedPath == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to retrieve scanned image.')),
        );
        return;
      }

      final file = File(scannedPath);
      if (!file.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File not found at: $scannedPath')),
        );
        return;
      }

      setState(() => _scannedImage = file);

      final recognizedText = await _extractTextFromImage(file.path);
      _autoFillFields(
        recognizedText.replaceAll('\n', ' ').replaceAll('\r', ' '),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Scan failed: $e')));
    }
  }

  Future<String?> _convertPdfToImage(String pdfPath) async {
    try {
      final doc = await PdfDocument.openFile(pdfPath);
      final page = await doc.getPage(1);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
      );
      await page.close();

      final imageFile = File('$pdfPath.jpg');
      await imageFile.writeAsBytes(pageImage!.bytes);
      return imageFile.path;
    } catch (e) {
      debugPrint('⚠️ PDF conversion failed: $e');
      return null;
    }
  }

  Future<String> _extractTextFromImage(String imagePath) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFilePath(imagePath);
    final recognizedText = await textRecognizer.processImage(inputImage);
    await textRecognizer.close();
    return recognizedText.text;
  }

  void _autoFillFields(String text) {
    final emailRegex = RegExp(r'[\w\.-]+@[\w\.-]+\.\w+');
    final phoneRegex = RegExp(r'(\+?\d[\d\s\-\(\)]{7,}\d)');
    final websiteRegex = RegExp(r'(https?:\/\/[^\s]+)|(www\.[^\s]+)');
    final nameRegex = RegExp(r'\b([A-Z][a-z]+(?: [A-Z][a-z]+)+)\b');
    final addressRegex = RegExp(
      r'(\d{1,5}\s+[A-Za-z0-9\s,.-]+(?:Street|St|Road|Rd|Avenue|Ave|Block|Sector|City|Town|Area|PO Box|Zip|PIN)\b)',
      caseSensitive: false,
    );
    final companyRegex = RegExp(
      r'\b(?:Company|Co\.|Pvt|Ltd|Inc|LLC|Enterprises|Technologies|Solutions|Studio|Group|Corporation|Labs|Agency|Systems|Industries)\b',
      caseSensitive: false,
    );

    final foundEmail = emailRegex.firstMatch(text)?.group(0);
    final foundPhone = phoneRegex.firstMatch(text)?.group(0);
    final foundWebsite = websiteRegex.firstMatch(text)?.group(0);
    final foundName = nameRegex.firstMatch(text)?.group(0);
    final foundAddress = addressRegex.firstMatch(text)?.group(0);

    String? foundCompany;
    final companyMatch = companyRegex.firstMatch(text);
    if (companyMatch != null) {
      final idx = companyMatch.start;
      final snippet = text.substring(
        (idx - 25).clamp(0, text.length),
        (idx + 40).clamp(0, text.length),
      );
      foundCompany = snippet.trim();
    }

    setState(() {
      name.text = foundName ?? name.text;
      company.text = foundCompany ?? company.text;
      mobile.text = foundPhone ?? mobile.text;
      email.text = foundEmail ?? email.text;
      website.text = foundWebsite ?? website.text;
      address.text = foundAddress ?? address.text;
    });
  }

  Future<void> _saveCardAndExit() async {
    final prefs = await SharedPreferences.getInstance();

    final newCard = BusinessCardModel(
      name: name.text,
      position: position.text,
      company: company.text,
      mobile: mobile.text,
      email: email.text,
      website: website.text,
      address: address.text,
      imagePath: _scannedImage?.path ?? '',
    );

    final existing = prefs.getStringList('savedCards') ?? [];
    existing.add(newCard.toJson());
    await prefs.setStringList('savedCards', existing);

    Get.snackbar(
      'Success',
      'Card saved successfully!',
      snackPosition: SnackPosition.TOP,
    );

    Navigator.pop(context);
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.deepPurple),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.deepPurple),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppbarWidget(
          title: 'Scan Business Card',
          leadingIcon: Icons.arrow_back,
          onLeadingIconTap: () => Get.back(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: scanDocument,
        child: const Icon(
          Icons.document_scanner_rounded,
          size: 28,
          color: Colors.white,
        ),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            children: [
              if (_scannedImage != null)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      _scannedImage!,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple.shade50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.deepPurple.shade100),
                  ),
                  child: const Center(
                    child: Text(
                      'No Scan Yet',
                      style: TextStyle(color: Colors.deepPurple, fontSize: 16),
                    ),
                  ),
                ),
              const SizedBox(height: 20),

              _buildTextField('Full Name', name, Icons.person_outline),
              _buildTextField('Position', position, Icons.work_outline),
              _buildTextField('Company', company, Icons.apartment_outlined),
              _buildTextField('Mobile', mobile, Icons.phone_android),
              _buildTextField('Email', email, Icons.email_outlined),
              _buildTextField('Website', website, Icons.language_outlined),
              _buildTextField('Address', address, Icons.location_on_outlined),

              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveCardAndExit,
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  'Save Card',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.deepPurple,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 5,
                  shadowColor: Colors.deepPurple.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
