import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_fonts.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(55),
          topRight: Radius.circular(55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, "Shop", "assets/svgs/shope.svg"),
          _buildNavItem(1, "Cart", "assets/svgs/cart.svg"),
          _buildNavItem(2, "Profile", "assets/svgs/ic_user_grey.svg"),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, String label, String iconPath) {
    final bool isActive = currentIndex == index;
    final Color activeColor = const Color(0xFF0079FF);
    final Color inactiveColor = const Color(0xFFC7C7C7);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: SvgPicture.asset(
              iconPath,
              key: ValueKey(isActive),
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(
                isActive ? activeColor : inactiveColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 6),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.sfPro,
              color: isActive ? activeColor : inactiveColor,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
