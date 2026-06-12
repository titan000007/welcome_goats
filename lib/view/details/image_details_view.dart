import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../controllers/gallery_controller.dart';
import '../../data/models/image_item.dart';

class ImageDetailsView extends StatelessWidget {
  ImageDetailsView({super.key});

  final GalleryController controller = Get.find<GalleryController>();

  @override
  Widget build(BuildContext context) {
    final ImageItem imgArg = Get.arguments as ImageItem;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: InteractiveViewer(
              minScale: 1.0,
              maxScale: 4.0,
              child: Image.network(
                imgArg.imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.white24, size: 64),
                      SizedBox(height: 16),
                      Text(
                        'Unable to load high-res image',
                        style: TextStyle(color: Colors.white24),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white10),
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                ),
                Obx(() {
                  final liveImg = controller.images.firstWhere(
                      (item) => item.id == imgArg.id,
                      orElse: () => imgArg);
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.toggleFavorite(liveImg.id),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Icon(
                            liveImg.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: liveImg.isFavorite
                                ? Colors.redAccent
                                : Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => controller.downloadImage(liveImg.id),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white10),
                          ),
                          child: const Icon(Icons.download,
                              color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: Obx(() {
              final liveImg = controller.images.firstWhere(
                  (item) => item.id == imgArg.id,
                  orElse: () => imgArg);
              return Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.bgDarkSheet.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Badge and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color:
                                    AppColors.primary.withValues(alpha: 0.2)),
                          ),
                          child: Text(
                            liveImg.category.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primaryLight,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        Text(
                          liveImg.uploadDate,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      liveImg.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Location tag
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 12, color: AppColors.primaryLight),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            liveImg.location,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      liveImg.description,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.45),
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Divider(color: AppColors.borderDark, height: 1),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: AppColors.bgDark,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person,
                                  color: AppColors.textDarkSecondary, size: 14),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'RECORDED BY',
                                  style: TextStyle(
                                      fontSize: 7.5,
                                      color: AppColors.textDarkSecondary,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  liveImg.uploaderName,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            _MetricWidget(
                              icon: Icons.download_done,
                              value: liveImg.downloadsCount.toString(),
                              label: 'Downloads',
                            ),
                            const SizedBox(width: 14),
                            _MetricWidget(
                              icon: Icons.heart_broken_sharp,
                              value: liveImg.isFavorite ? 'Loved' : 'Liking',
                              label: 'Status',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _MetricWidget extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _MetricWidget({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Icon(icon, size: 10, color: AppColors.primaryLight),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
              fontSize: 7,
              color: AppColors.textDarkSecondary,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
