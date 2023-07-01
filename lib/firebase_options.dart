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
    apiKey: 'AIzaSyCvqdMIS07_miNfp4ddi9eYyUAfsyYdBvA',
    appId: '1:920528100484:web:652108b276fafeef7076d1',
    messagingSenderId: '920528100484',
    projectId: 'blackjack-b3fc5',
    authDomain: 'blackjack-b3fc5.firebaseapp.com',
    storageBucket: 'blackjack-b3fc5.appspot.com',
    measurementId: 'G-BDBSHKBNCY',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAurW7M9bVWo0ApB2uCoL5gZStuZsOhhj0',
    appId: '1:920528100484:android:56eba4f790aec90e7076d1',
    messagingSenderId: '920528100484',
    projectId: 'blackjack-b3fc5',
    storageBucket: 'blackjack-b3fc5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOSFxtA2xD9o6c5qWXrcfLBMCZQIIHp4U',
    appId: '1:920528100484:ios:c48fcc11806fa9e27076d1',
    messagingSenderId: '920528100484',
    projectId: 'blackjack-b3fc5',
    storageBucket: 'blackjack-b3fc5.appspot.com',
    iosClientId:
        '920528100484-2evm7bthuep1e8o74e868nrsgcnijeig.apps.googleusercontent.com',
    iosBundleId: 'com.example.project',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAOSFxtA2xD9o6c5qWXrcfLBMCZQIIHp4U',
    appId: '1:920528100484:ios:c48fcc11806fa9e27076d1',
    messagingSenderId: '920528100484',
    projectId: 'blackjack-b3fc5',
    storageBucket: 'blackjack-b3fc5.appspot.com',
    iosClientId:
        '920528100484-2evm7bthuep1e8o74e868nrsgcnijeig.apps.googleusercontent.com',
    iosBundleId: 'com.example.project',
  );
}
