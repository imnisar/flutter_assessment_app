import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_assessment_app/features/auth/presentation/login_screen.dart';
import 'package:flutter_assessment_app/features/home/presentation/shop_screen.dart';
import 'package:flutter_assessment_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_assessment_app/core/services/auth_service.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuthService extends Mock implements AuthService {}
class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockAuthService mockAuthService;
  late MockUserCredential mockUserCredential;

  setUp(() {
    mockAuthService = MockAuthService();
    mockUserCredential = MockUserCredential();
    
    when(() => mockAuthService.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          username: any(named: 'username'),
          birthday: any(named: 'birthday'),
        )).thenAnswer((_) async => mockUserCredential);
  });

  testWidgets('Full Signup Integration Flow Test', (tester) async {
    await mockNetworkImages(() async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
          GoRoute(path: '/home', builder: (_, __) => const ShopScreen()),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authServiceProvider.overrideWithValue(mockAuthService),
          ],
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );

      // Verify Initial State
      expect(find.text('Welcome!'), findsOneWidget);

      // Fill in fields
      await tester.enterText(find.byType(TextField).at(0), 'test@example.com');
      await tester.enterText(find.byType(TextField).at(1), 'tester');
      await tester.enterText(find.byType(TextField).at(2), '14/08/1995');
      await tester.enterText(find.byType(TextField).at(3), 'Password123!');
      await tester.pumpAndSettle();

      // Find Next text (inside GestureDetector)
      final nextFinder = find.text('Next');
      await tester.tap(nextFinder);
      
      // 1. Wait for loading state
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      
      // 2. Wait for async cleanup
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      // 3. Verify Navigation
      // Shop Screen has "For You" and "World"
      expect(find.text('Welcome!'), findsNothing);
      expect(find.text('For You'), findsOneWidget); 
    });
  });
}
