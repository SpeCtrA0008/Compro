// File generated for Firebase configuration
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return windows;
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
    apiKey: 'AIzaSyBqxBzR7qkP_vQxZ8xYhG3jN2mK5wL9pQo',
    appId: '1:123456789012:web:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'watric-cf76f',
    authDomain: 'watric-cf76f.firebaseapp.com',
    databaseURL: 'https://watric-cf76f-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'watric-cf76f.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBqxBzR7qkP_vQxZ8xYhG3jN2mK5wL9pQo',
    appId: '1:123456789012:android:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'watric-cf76f',
    databaseURL: 'https://watric-cf76f-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'watric-cf76f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBqxBzR7qkP_vQxZ8xYhG3jN2mK5wL9pQo',
    appId: '1:123456789012:ios:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'watric-cf76f',
    databaseURL: 'https://watric-cf76f-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'watric-cf76f.appspot.com',
    iosBundleId: 'com.watric.flutterFramework',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBqxBzR7qkP_vQxZ8xYhG3jN2mK5wL9pQo',
    appId: '1:123456789012:macos:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'watric-cf76f',
    databaseURL: 'https://watric-cf76f-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'watric-cf76f.appspot.com',
    iosBundleId: 'com.watric.flutterFramework',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBqxBzR7qkP_vQxZ8xYhG3jN2mK5wL9pQo',
    appId: '1:123456789012:windows:abcdef1234567890',
    messagingSenderId: '123456789012',
    projectId: 'watric-cf76f',
    databaseURL: 'https://watric-cf76f-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'watric-cf76f.appspot.com',
  );
}
