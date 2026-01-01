Card Scanner App (Flutter + Firebase)

A modern Business Card Scanner application built using Flutter, integrated with Firebase for authentication, cloud storage, and real-time database.
The app scans business cards using OCR, extracts contact details automatically, and stores them securely in the cloud.

$ Features
# Card Scanning & OCR

Scan business cards using device camera

Automatic text extraction (Name, Phone, Email, Company, Position)

Auto-fill contact form after scan

# Firebase Integration

Firebase Authentication (Email & Password)

Cloud Firestore for storing card details

Firebase Storage for card images

Real-time sync across devices

Secure per-user data storage

# Card Management

Add, edit, delete scanned cards

Mark/unmark cards as favorites

Favorite cards screen

Search cards by name, company, or email

# UI & UX

Clean and modern UI

Grid view for scanned cards

Bottom navigation (Home, Category, Scan, Favorite, Profile)

Smooth navigation & animations

# Tech Stack
Layer	Technology
Frontend	Flutter (Dart)
OCR	Google ML Kit
Authentication	Firebase Auth
Database	Cloud Firestore
Image Storage	Firebase Storage
State Management	GetX
Platform	Android / iOS

# Project Structure
lib/
 ├── controller/
 │   ├── card_controller.dart
 │   ├── favorite_controller.dart
 │   └── category_controller.dart
 │
 ├── modal/
 │   └── cardmodal.dart
 │
 ├── services/
 │   ├── firebase_service.dart
 │   └── auth_service.dart
 │
 ├── view/
 │   ├── homescreen/
 │   ├── scan_view/
 │   ├── login/
 │   ├── onboarding/
 │   └── detail_pages/
 │
 ├── widgets/
 │   └── appbar_widget.dart
 │
 ├── splash.dart
 └── main.dart

# Firebase Data Structure
Firestore
users
 └── {userId}
     └── cards
         └── {cardId}
             ├── name
             ├── phone
             ├── email
             ├── position
             ├── company
             ├── imageUrl
             ├── isFavorite
             └── createdAt

Firebase Storage
cards/
 └── {userId}/
     └── card_image.jpg



# Dependencies
firebase_core
firebase_auth
cloud_firestore
firebase_storage
google_ml_kit
image_picker
flutter_image_compress
get

# Setup Instructions
1️⃣ Clone the Repository
git clone https://github.com/Austin081104/card-scanner-privacy-policy.git
cd card-scanner

2️⃣ Install Dependencies
flutter pub get

3️⃣ Firebase Configuration

Create a Firebase project

Enable:

Authentication → Email/Password

Cloud Firestore

Firebase Storage

Download:

google-services.json → android/app/

GoogleService-Info.plist → ios/Runner/

4️⃣ Run the App
flutter run

📱 Screens Included

Splash Screen

Onboarding Screens

Login / Signup

Home (Scanned Cards)

Scan Card

Card Details

Favorites

Profile

Terms & Conditions

Privacy Policy


👨‍💻 Developer

Austin Chettiar
📧 Email: austin.c081104@gmail.com
🔗 GitHub: https://github.com/Austin081104

📄 License

This project is for learning and demonstration purposes.
Feel free to fork and enhance.
