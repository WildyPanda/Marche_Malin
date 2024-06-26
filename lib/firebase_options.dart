// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQe_FK4eWQptx4yXKZDJxv11lUPiy1XeE',
    appId: '1:402083965163:web:503238a584dcd9ef79b6ae',
    messagingSenderId: '402083965163',
    projectId: 'marche-malin',
    authDomain: 'marche-malin.firebaseapp.com',
    storageBucket: 'marche-malin.appspot.com',
    measurementId: 'G-HEP7SN9ZXE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBoqKNTU5SoIF6jUu4APctvktYNlF4xBjY',
    appId: '1:402083965163:android:d283d8f6ac71643679b6ae',
    messagingSenderId: '402083965163',
    projectId: 'marche-malin',
    storageBucket: 'marche-malin.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCpk60vIhwBtDcB8mGwlaXyf6pSG0L9kqo',
    appId: '1:402083965163:ios:dcd9b305dd59d05e79b6ae',
    messagingSenderId: '402083965163',
    projectId: 'marche-malin',
    storageBucket: 'marche-malin.appspot.com',
    iosBundleId: 'com.example.marcheMalin',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCpk60vIhwBtDcB8mGwlaXyf6pSG0L9kqo',
    appId: '1:402083965163:ios:76b67c64dde9f3a379b6ae',
    messagingSenderId: '402083965163',
    projectId: 'marche-malin',
    storageBucket: 'marche-malin.appspot.com',
    iosBundleId: 'com.example.marcheMalin.RunnerTests',
  );
}
