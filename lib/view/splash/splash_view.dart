import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../routes/app_pages.dart';
import '../../widgets/common_button.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.bgDark,
          image: DecorationImage(
            image: NetworkImage(
              'https://images.unsplash.com/photo-1547036967-23d11aacaee0?q=80&w=600&auto=format&fit=crop',
            ),
            fit: BoxFit.cover,
            opacity: 0.18,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 1.5),
                      ),
                      child: const Icon(
                        Icons.local_florist,
                        color: AppColors.primaryLight,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'WELCOME GOATS',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'SPECIES SANCTUARY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryLight,
                        letterSpacing: 3.5,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text(
                      'Preserve, Explore & Share the Wilderness',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDarkPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Step into an immersive catalog preserving animals, exquisite birds, and nature landscapes recorded by wildlife experts globally.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textDarkSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 36),
                    CommonButton(
                      text: 'Step inside active feed',
                      onPressed: () {
                        Get.offNamed(AppRoutes.login);
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text('GETX ARCHITECTURE DESIGN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 8.5,
                            color: AppColors.primaryLight,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'monospace')),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
