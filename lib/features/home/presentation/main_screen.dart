import 'package:flutter/material.dart';
import 'package:flutter_assessment_app/features/home/presentation/shop_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/custom_bottom_nav_bar.dart';
import 'providers/shop_provider.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ShopScreen(),
    const Center(child: Text("Cart Screen", style: TextStyle(fontSize: 24))),
    const Center(child: Text("Profile Screen", style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    final shopState = ref.watch(shopProvider);
    double navOpacity = _currentIndex == 0 ? (1.0 - (shopState.scrollOffset / 300)).clamp(0.0, 1.0) : 1.0;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Opacity(
        opacity: navOpacity,
        child: CustomBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
