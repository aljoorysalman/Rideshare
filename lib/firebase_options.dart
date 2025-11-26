// File generated manually for Flutter Web, Android.


import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'iOS options not configured.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'macOS options not configured.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'Windows options not configured.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Linux options not configured.',
        );
      default:
        throw UnsupportedError(
          'Platform not supported.',
        );
    }
  }

 
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCRNyxmViUktFLs6PhpeRAHfgzE-OYAU7w",
    authDomain: "rideshare-b9261.firebaseapp.com",
    projectId: "rideshare-b9261",
    storageBucket: "rideshare-b9261.firebasestorage.app",
    messagingSenderId: "689388328534",
    appId: "1:689388328534:web:234b024e8b522714c4cdf7",
  );


  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBr1rK-J9eaG96KHYXnXZG8sLRypiYTNZw",
    appId: "1:689388328534:android:2706f316af08f2eac4cdf7",
    messagingSenderId: "689388328534",
    projectId: "rideshare-b9261",
    storageBucket: "rideshare-b9261.firebasestorage.app",
  );
}
