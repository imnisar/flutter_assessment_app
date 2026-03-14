import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_assessment_app/core/constants/app_images.dart';
import 'package:flutter_assessment_app/core/extensions/size_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_fonts.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hint;
  final String iconPath;
  final String? activeIconPath;
  final bool isPassword;
  final bool isActive;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.iconPath,
    this.activeIconPath,
    this.isPassword = false,
    this.isActive = false,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    const Duration animDuration = Duration(milliseconds: 600);
    const Curve animCurve = Curves.easeInOut;
    final Color inactiveColor = const Color(0xFF737373).withValues(alpha: 0.16);

    final double textScale = MediaQuery.textScalerOf(context).scale(1.0);

    return AnimatedContainer(
      duration: animDuration,
      curve: animCurve,
      constraints: BoxConstraints(minHeight: 67 * textScale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: inactiveColor,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: AnimatedCrossFade(
              firstChild: SvgPicture.asset(iconPath, width: 22, height: 22),
              secondChild: activeIconPath != null
                  ? SvgPicture.asset(activeIconPath!, width: 22, height: 22)
                  : SvgPicture.asset(iconPath, width: 22, height: 22),
              crossFadeState: isActive ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              duration: animDuration,
              firstCurve: animCurve,
              secondCurve: animCurve,
              sizeCurve: animCurve,
            ),
          ),
          const SizedBox(width: 15),
          const SizedBox(
            height: 25,
            child: VerticalDivider(
              color: Color(0xFFDDDDDD),
              thickness: 1,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedDefaultTextStyle(
                  duration: animDuration,
                  curve: animCurve,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFC7C7C7),
                  ),
                  child: Text(label),
                ),
                const SizedBox(height: 2),
                TextField(
                  controller: controller,
                  obscureText: isPassword,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  inputFormatters: inputFormatters,
                  style: const TextStyle(
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: Color(0xFF000000),
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(
                      color: Color(0xFFC5C3C3),
                      fontFamily: AppFonts.poppins,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          if (isPassword)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: SvgPicture.asset(
                AppImages.icEye,
                width: 20,
              ),
            ),
        ],
      ),
    );
  }
}