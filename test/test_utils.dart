import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback = Function(MethodCall call);

void setupFirebaseMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('plugins.flutter.io/firebase_core');

  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'Firebase#initializeApp') {
      return {
        'name': '[DEFAULT]',
        'options': {
          'apiKey': '123',
          'appId': '123',
          'messagingSenderId': '123',
          'projectId': '123',
        },
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      return customHandlers(methodCall);
    }

    return null;
  });
}

Future<void> initializeMockFirebase() async {
  setupFirebaseMocks();
  await Firebase.initializeApp();
}
