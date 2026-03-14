import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_assessment_app/core/constants/app_images.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_fonts.dart';
import '../providers/shop_provider.dart';

class CustomBottomNavBar extends ConsumerWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollOffset = ref.watch(shopProvider.select((s) => s.scrollOffset));
    final bool isGlassy = scrollOffset > 400;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: isGlassy ? 5 : 0,
          sigmaY: isGlassy ? 5 : 0,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 80,
          padding: const EdgeInsets.only(bottom: 6, top: 6),
          decoration: BoxDecoration(
            color: isGlassy 
                ? Colors.white.withValues(alpha: 0.35)
                : Colors.white,

            border: Border.all(
              color: isGlassy 
                  ? Colors.white.withValues(alpha: 0.2) 
                  : Colors.transparent, 
              width: 0.5,
            ),
            boxShadow: isGlassy ? const [
              BoxShadow(
                color: Color(0x40EFEFEF),
                offset: Offset(0, 4),
                blurRadius: 4,
              ),
            ] : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, "Shop", AppImages.icShop),
              _buildNavItem(1, "Cart", AppImages.cart),
              _buildNavItem(2, "Profile", AppImages.icUserGrey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    final bool isActive = currentIndex == index;
    const Color activeColor = Color(0xFF0079FF);
    const Color inactiveColor = Color(0xFFC7C7C7);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: SvgPicture.asset(
                iconPath,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isActive ? activeColor : inactiveColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                fontFamily: AppFonts.dmSans,
                color: isActive ? activeColor : inactiveColor,
              ),
              child: Text(label),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                height: 2,
                width: 4,
                decoration: const BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}