import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../controllers/gallery_controller.dart';
import '../../routes/app_pages.dart';
import './widgets/home_card_widget.dart';

class HomeView extends GetView<GalleryController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: const Column(
          children: [
            Text(
              'WILDLIFE ARCHIVE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2.0,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'WELCOME GOATS',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryLight,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          const SizedBox(width: 55),
          IconButton(
              icon: const Icon(Icons.auto_awesome,
                  color: AppColors.accent, size: 20),
              onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              controller: controller.searchController,
              style: const TextStyle(
                  fontSize: 13, color: AppColors.textDarkPrimary),
              decoration: InputDecoration(
                hintText: 'Search species, locations, tags...',
                hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textDarkSecondary, size: 18),
                suffixIcon: Obx(() => controller.rxSearchQuery.value.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppColors.textDarkSecondary, size: 18),
                        onPressed: () {
                          controller.searchController.clear();
                        },
                      )
                    : const SizedBox.shrink()),
                filled: true,
                fillColor: AppColors.bgDarkSheet,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.borderDark),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 42,
            child: Obx(() {
              final current = controller.rxCategoryFilter.value;
              final categories = ['All', 'Animals', 'Birds', 'Nature'];
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = cat == current;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.black
                              : AppColors.textDarkSecondary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primaryLight,
                      backgroundColor: AppColors.bgDarkSheet,
                      side: BorderSide(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.borderDark),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onSelected: (_) {
                        controller.rxCategoryFilter.value = cat;
                      },
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Obx(() {
              final items = controller.filteredImages;
              if (items.isEmpty) {
                return _buildEmptyState();
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                itemCount: items.length,
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.90,
                ),
                itemBuilder: (context, index) {
                  final img = items[index];
                  return Obx(() {
                    final currentImg = controller.images
                        .firstWhere((element) => element.id == img.id);
                    return HomeCardWidget(
                      image: currentImg.imageUrl,
                      title: currentImg.title,
                      cardText: currentImg.category,
                      isSelected: currentImg.isFavorite,
                      location: currentImg.location,
                      onTap: () {
                        Get.toNamed(AppRoutes.details, arguments: currentImg);
                      },
                      onFavoriteTap: () =>
                          controller.toggleFavorite(currentImg.id),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 48, color: Colors.white24),
          const SizedBox(height: 12),
          const Text(
            'No matching wildlife found',
            style: TextStyle(
                color: AppColors.textDarkSecondary,
                fontSize: 13,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Try relaxing your category or search query parameters.',
            style: TextStyle(
                color: Colors.white.withValues(alpha: 0.2), fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgDarkSheet,
        border: Border(top: BorderSide(color: AppColors.borderDark)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NavBarItem(
                icon: Icons.grain,
                label: 'Archives',
                isActive: true,
                onTap: () {},
              ),
              NavBarItem(
                icon: Icons.add_a_photo_outlined,
                label: 'Submit',
                isActive: false,
                onTap: () => Get.toNamed(AppRoutes.upload),
              ),
              NavBarItem(
                icon: Icons.bookmark_border,
                label: 'My Collection',
                isActive: false,
                onTap: () => Get.toNamed(AppRoutes.myUploads),
              ),
              NavBarItem(
                icon: Icons.person_outline,
                label: 'Profile',
                isActive: false,
                onTap: () => Get.toNamed(AppRoutes.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : AppColors.textDarkSecondary,
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                color:
                    isActive ? AppColors.primary : AppColors.textDarkSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
