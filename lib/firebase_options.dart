import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Options Firebase générées par `flutterfire configure`.
///
/// ⚠️ REMPLACER ce fichier par la sortie de :
///   flutterfire configure
/// (connecte-toi à Firebase, sélectionne ton projet, puis choisis les
/// plateformes android/ios/web). Les clés ci-dessous sont des PLACEHOLDERS
/// et seront remplacées automatiquement.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        return web;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyPLACEHOLDER_ANDROID',
    appId: '1:000000000000:android:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'todo-pro-placeholder',
    storageBucket: 'todo-pro-placeholder.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyPLACEHOLDER_IOS',
    appId: '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'todo-pro-placeholder',
    storageBucket: 'todo-pro-placeholder.appspot.com',
    iosBundleId: 'com.akaletekof.todoPro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyPLACEHOLDER_MACOS',
    appId: '1:000000000000:ios:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'todo-pro-placeholder',
    storageBucket: 'todo-pro-placeholder.appspot.com',
    iosBundleId: 'com.akaletekof.todoPro',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyPLACEHOLDER_WINDOWS',
    appId: '1:000000000000:web:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'todo-pro-placeholder',
    authDomain: 'todo-pro-placeholder.firebaseapp.com',
    storageBucket: 'todo-pro-placeholder.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyPLACEHOLDER_WEB',
    appId: '1:000000000000:web:0000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'todo-pro-placeholder',
    authDomain: 'todo-pro-placeholder.firebaseapp.com',
    storageBucket: 'todo-pro-placeholder.appspot.com',
  );
}