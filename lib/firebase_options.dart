import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

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
      default:
        throw UnsupportedError('Unsupported platform');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBhsfLQsKtE3K1s0HKpHKk2ayFnyEHA52Q',
    appId: '1:1093703358344:android:9e51e51854c5c8ad8e70a9',
    messagingSenderId: '1093703358344',
    projectId: 'ictu-guide',
    storageBucket: 'ictu-guide.firebasestorage.app',
    authDomain: 'ictu-guide.firebaseapp.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhsfLQsKtE3K1s0HKpHKk2ayFnyEHA52Q',
    appId: '1:1093703358344:ios:7aed39f5a1ecdb938e70a9',
    messagingSenderId: '1093703358344',
    projectId: 'ictu-guide',
    storageBucket: 'ictu-guide.firebasestorage.app',
    androidClientId: '1093703358344-jgjsl2brk1sg6j3g3dbn0i2po2te3616.apps.googleusercontent.com',
    iosClientId: '1093703358344-6gc3t5gpdfqrj1m5ec2r52n4dntki33k.apps.googleusercontent.com',
    iosBundleId: 'com.ictu.guide',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBhsfLQsKtE3K1s0HKpHKk2ayFnyEHA52Q',
    appId: '1:1093703358344:web:63d0fad7f4bfed758e70a9',
    messagingSenderId: '1093703358344',
    projectId: 'ictu-guide',
    authDomain: 'ictu-guide.firebaseapp.com',
    storageBucket: 'ictu-guide.firebasestorage.app',
    measurementId: 'G-XXXXXXXXXX',
  );
}