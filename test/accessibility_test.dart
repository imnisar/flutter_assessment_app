import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:flutter_assessment_app/features/auth/presentation/login_screen.dart';
import 'package:flutter_assessment_app/features/home/presentation/shop_screen.dart';
import 'package:flutter_assessment_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_assessment_app/core/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  group('Accessibility Tests', () {
    testWidgets('LoginScreen supports 200% text scaling without overflow', (tester) async {
      await mockNetworkImages(() async {
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        addTearDown(() => tester.platformDispatcher.clearTextScaleFactorTestValue());

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authServiceProvider.overrideWithValue(mockAuthService),
            ],
            child: const MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify no overflow errors
        expect(tester.takeException(), isNull);
      });
    });

    testWidgets('ShopScreen supports 200% text scaling without overflow', (tester) async {
      await mockNetworkImages(() async {
        tester.platformDispatcher.textScaleFactorTestValue = 2.0;
        addTearDown(() => tester.platformDispatcher.clearTextScaleFactorTestValue());

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              authServiceProvider.overrideWithValue(mockAuthService),
            ],
            child: const MaterialApp(
              home: ShopScreen(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      });
    });
  });
}
