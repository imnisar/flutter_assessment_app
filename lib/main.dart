import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_assessment_app/core/constants/app_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'firebase_options.dart';
import 'core/config/custom_screen_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize in background
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Flutter Assessment',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      builder: (context, child) {
        CustomScreenUtil.init(context);
        return child!;
      },
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: AppFonts.sfPro,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0079FF),
        ),
      ),
    );
  }
}
