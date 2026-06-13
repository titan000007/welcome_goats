import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../controllers/gallery_controller.dart';
import '../../data/models/image_item.dart';
import '../../widgets/common_button.dart';
import '../../widgets/common_textfield.dart';
import '../../utils/app_toast.dart';

class UploadView extends StatefulWidget {
  const UploadView({super.key});

  @override
  State<UploadView> createState() => _UploadViewState();
}

class _UploadViewState extends State<UploadView> {
  final GalleryController controller = Get.find<GalleryController>();

  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String category = 'Animals';
  String imageUrl = 'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?q=80&w=600&auto=format&fit=crop';
  bool isUploading = false;

  final List<String> presetImages = [
    'https://images.unsplash.com/photo-1516467508483-a7212febe31a?q=80&w=600&auto=format&fit=crop', // Snowy wolf
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?q=80&w=600&auto=format&fit=crop', // Pygmy Owl
    'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=600&auto=format&fit=crop', // Cascade
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=600&auto=format&fit=crop', // Oceanic coast
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'SUBMIT SPECIES',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Selector for Photo placeholder / Preset asset picker
            const Text(
              'CHOOSE CAPTURED RECORDING',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkSecondary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.bgDarkSheet,
                border: Border.all(color: AppColors.borderDark),
                borderRadius: BorderRadius.circular(22),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.photo_library, size: 10, color: AppColors.primaryLight),
                          SizedBox(width: 4),
                          Text(
                            'PRESET CHOSEN',
                            style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Sample asset carousel picker
            SizedBox(
              height: 60,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: presetImages.length,
                itemBuilder: (context, idx) {
                  final url = presetImages[idx];
                  final isSelected = imageUrl == url;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        imageUrl = url;
                      });
                    },
                    child: Container(
                      width: 60,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.borderDark,
                          width: isSelected ? 2 : 1.5,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 18),

            // 2. Title Field
            CommonTextField(
              label: 'Species title',
              hintText: 'e.g., Majestic Horned Caribou',
              controller: titleController,
            ),

            const SizedBox(height: 16),

            // 3. Category selector radio grid
            const Text(
              'TAXONOMY CATEGORY',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: AppColors.textDarkSecondary,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Animals', 'Birds', 'Nature'].map((cat) {
                final isSelected = category == cat;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        category = cat;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withOpacity(0.08) : AppColors.bgDarkSheet,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.borderDark,
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            cat == 'Animals'
                                ? Icons.pets
                                : cat == 'Birds'
                                    ? Icons.wb_twilight
                                    : Icons.forest,
                            color: isSelected ? AppColors.primaryLight : AppColors.textDarkSecondary,
                            size: 16,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cat,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.textDarkPrimary : AppColors.textDarkSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // 4. Location Field
            CommonTextField(
              label: 'Capture location',
              hintText: 'e.g., Denali National Park, Alaska',
              controller: locationController,
            ),

            const SizedBox(height: 16),

            // 5. Description Field
            CommonTextField(
              label: 'Description / field notes',
              hintText: 'Describe behaviors, climate, and observation environments...',
              controller: descriptionController,
              maxLines: 3,
            ),

            const SizedBox(height: 24),

            // Submit Button
            isUploading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : CommonButton(
                    text: 'Publish species to database',
                    onPressed: () {
                      if (titleController.text.trim().isEmpty) {
                        AppToast.show('Please enter a species title!', isError: true);
                        return;
                      }

                      setState(() {
                        isUploading = true;
                      });

                      // Simulate upload lag
                      Future.delayed(const Duration(milliseconds: 1200), () {
                        final newItem = ImageItem(
                          id: 'upload_${DateTime.now().millisecondsSinceEpoch}',
                          title: titleController.text.trim(),
                          description: descriptionController.text.trim().isEmpty
                              ? 'A magnificent visual snapshot registered by custom uploader.'
                              : descriptionController.text.trim(),
                          category: category,
                          imageUrl: imageUrl,
                          uploadDate: DateTime.now().toString().substring(0, 10),
                          uploaderName: 'Denver Brooks',
                          location: locationController.text.trim().isEmpty
                              ? 'Unknown Sanctuary Point'
                              : locationController.text.trim(),
                          downloadsCount: 0,
                          likesCount: 0,
                          userId: 'user_default', // marks as My Uploads
                          isFavorite: false,
                        );

                        // controller.addProduct(newItem);
                        // AppToast.show('Species published successfully!');
                        Get.back();
                      });
                    },
                  ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
