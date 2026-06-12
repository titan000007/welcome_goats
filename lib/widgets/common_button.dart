import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isSecondary;

  const CommonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isSecondary
              ? null
              : const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
          color: isSecondary ? AppColors.bgDarkSheet : null,
          border: isSecondary ? Border.all(color: AppColors.borderDark, width: 1.5) : null,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            text.toUpperCase(),
            style: TextStyle(
              color: isSecondary ? AppColors.textDarkPrimary : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
