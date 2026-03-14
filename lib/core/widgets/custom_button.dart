import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({required this.text, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 297,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(62),
        gradient: const LinearGradient(
          colors: [Color(0xFFE4E4E4), Color(0xFF808080)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0079FF).withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
            spreadRadius: -10,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(62)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF2B2B2C),
            fontSize: 18,
            fontWeight: FontWeight.w800,
            fontFamily: 'SF Pro Text',
          ),
        ),
      ),
    );
  }
}