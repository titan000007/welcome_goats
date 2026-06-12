import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool? showBorder;
  final double? height;

  const CommonButton(
      {super.key,
      required this.onTap,
      required this.title,
      this.showBorder = false,
      this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height ?? 48.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF00E5A8),
              Color(0xFF00C98D),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00E5A8).withValues(alpha: .4),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
