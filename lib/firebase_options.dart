import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('DefaultFirebaseOptions are not supported for web.');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError('DefaultFirebaseOptions are not supported for this platform.');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA2YoJPq88KkU36s0j26KFxm4zCsdSI4Ok',
    appId: '1:353651713256:android:5fab9595d158845206d55d',
    messagingSenderId: '353651713256',
    projectId: 'flutter-assessment-5bf1b',
    storageBucket: 'flutter-assessment-5bf1b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBH9S3ELhCP4ZgOs7473Mu-SIkrToW3WTo',
    appId: '1:353651713256:ios:ecbd695dc8c76b1506d55d',
    messagingSenderId: '353651713256',
    projectId: 'flutter-assessment-5bf1b',
    storageBucket: 'flutter-assessment-5bf1b.firebasestorage.app',
    iosBundleId: 'com.example.flutterAssessmentApp',
  );

}