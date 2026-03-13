import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => android;

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD07vYslhDno9fkcK95C2JslnOpx_erxBg',
    appId: '1:426834336038:android:2793689ab2c92c2e0ac9e7',
    messagingSenderId: '426834336038',
    projectId: 'task-manager-d7b3c',
    storageBucket: 'task-manager-d7b3c.firebasestorage.app',
  );
}
