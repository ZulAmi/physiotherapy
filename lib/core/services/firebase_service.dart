import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        // For web, you need these options
        options: kIsWeb
            ? const FirebaseOptions(
                apiKey: "YOUR_API_KEY",
                authDomain: "your-app.firebaseapp.com",
                projectId: "your-app",
                storageBucket: "your-app.appspot.com",
                messagingSenderId: "123456789",
                appId: "1:123456789:web:abcdef123456789",
              )
            : null, // For native platforms, Firebase reads from google-services.json/GoogleService-Info.plist
      );

      if (kDebugMode) {
        print("Firebase initialized successfully");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Firebase initialization failed: $e");
      }
    }
  }
}
