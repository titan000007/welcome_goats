import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../controllers/gallery_controller.dart';
import '../../routes/app_pages.dart';
import '../../widgets/common_button.dart';

class ProfileView extends StatelessWidget {
  ProfileView({super.key});

  final GalleryController controller = Get.find<GalleryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'MEMBER PROFILE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // 1. Sleek avatar card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgDarkSheet,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified, size: 14, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Denver Brooks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'HEAD WILDLIFE RANGER • ID-2026',
                    style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.primaryLight, letterSpacing: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 2. Metrics grid card
            Obx(() {
              final totalUploads = controller.images.where((img) => img.userId == 'user_default').length;
              final totalFavorites = controller.images.where((img) => img.isFavorite).length;
              final totalDownloads = controller.images.fold<int>(0, (sum, item) => sum + item.downloadsCount);

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.myUploads),
                          child: _StatCard(
                            title: 'My Species logs',
                            value: totalUploads.toString(),
                            icon: Icons.assignment_turned_in,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          title: 'Saved favorites',
                          value: totalFavorites.toString(),
                          icon: Icons.favorite,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Asset downloads',
                          value: totalDownloads.toString(),
                          icon: Icons.download_done_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: _StatCard(
                          title: 'Active Rank',
                          value: 'Elite',
                          icon: Icons.stars,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),

            const SizedBox(height: 24),

            // 3. Settings / preferences block
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ACCOUNT PREFERENCES',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textDarkSecondary, letterSpacing: 1.2),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bgDarkSheet,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Column(
                children: [
                  Obx(() {
                    final curr = controller.rxIsLightTheme.value;
                    return ListTile(
                      leading: Icon(curr ? Icons.wb_sunny : Icons.nightlight_round, color: AppColors.primaryLight, size: 20),
                      title: const Text('Sanctuary visual theme', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(curr ? 'Polished Light colors' : 'Nature forest Dark', style: TextStyle(fontSize: 9.5, color: Colors.white.withOpacity(0.3))),
                      trailing: Switch(
                        value: curr,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          controller.rxIsLightTheme.value = val;
                          Get.changeTheme(val ? ThemeData.light() : ThemeData.dark());
                        },
                      ),
                    );
                  }),
                  const Divider(color: AppColors.borderDark, height: 1),
                  ListTile(
                    leading: const Icon(Icons.security, color: AppColors.primaryLight, size: 20),
                    title: const Text('Encryption & credentials', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 12),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Log Out Button
            CommonButton(
              text: 'Log out from sanctuary',
              isSecondary: true,
              onPressed: () {
                Get.dialog(
                  AlertDialog(
                    backgroundColor: AppColors.bgDarkSheet,
                    surfaceTintColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.borderDark),
                    ),
                    title: const Text('Log Out', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    content: const Text('Are you sure you want to end your active session?', style: TextStyle(color: AppColors.textDarkSecondary, fontSize: 12)),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('CANCEL', style: TextStyle(color: AppColors.textDarkSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Get.back(); // close alert dialog
                          Get.offAllNamed(AppRoutes.splash);
                        },
                        child: const Text('END', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgDarkSheet,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(fontSize: 8, color: AppColors.textDarkSecondary, fontWeight: FontWeight.bold),
              ),
              Icon(icon, size: 14, color: AppColors.primaryLight),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
