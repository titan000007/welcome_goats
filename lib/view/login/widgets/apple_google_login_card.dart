import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class AppleGoogleLoginCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;
  final Color? color;
  const AppleGoogleLoginCard(
      {super.key,
      required this.title,
      required this.image,
      required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      hoverColor: Colors.grey,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xff2d2e2d),
              width: 1,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(image),
              width: 24,
              height: 24,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textLightSecondary),
            )
          ],
        ),
      ),
    );
  }
}
