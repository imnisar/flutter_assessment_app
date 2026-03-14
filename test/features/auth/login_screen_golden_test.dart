import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_assessment_app/features/auth/presentation/login_screen.dart';

void main() {
  group('LoginScreen Golden Tests', () {
    testGoldens('LoginScreen - Empty State', (tester) async {
      await loadAppFonts();
      
      final builder = DeviceBuilder()
        ..overrideDevicesForAllScenarios(devices: [
          Device.phone,
          Device.iphone11,
        ])
        ..addScenario(
          name: 'Default state',
          widget: const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

      await tester.pumpDeviceBuilder(builder);
      await screenMatchesGolden(tester, 'login_screen_empty');
    });
  });
}
