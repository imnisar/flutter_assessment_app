import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_assessment_app/features/home/presentation/main_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
final initialAuthStateProvider = Provider<bool>((ref) {
  return false; 
});

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(),
      ),
    ],
  );
});