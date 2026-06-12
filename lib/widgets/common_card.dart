import 'package:flutter/material.dart';
import '../utils/colors.dart';

class CommonCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const CommonCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgDarkSheet,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderDark),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: child,
        ),
      ),
    );
  }
}
