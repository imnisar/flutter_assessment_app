import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:flutter_assessment_app/features/home/presentation/shop_screen.dart';

void main() {
  group('ShopScreen Golden Tests', () {
    testGoldens('ShopScreen - Default State', (tester) async {
      await mockNetworkImages(() async {
        await loadAppFonts();
        
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [
            Device.phone,
            Device.iphone11,
          ])
          ..addScenario(
            name: 'Shop Screen Default',
            widget: const ProviderScope(
              child: MaterialApp(
                home: ShopScreen(),
              ),
            ),
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'shop_screen_default');
      });
    });
  });
}
