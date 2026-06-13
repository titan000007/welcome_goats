import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../data/models/image_item.dart';
import '../data/repositories/image_repository.dart';
import '../data/repositories/firebase_upload_repository.dart';
import '../utils/app_toast.dart';

class GalleryController extends GetxController {
  var images = <ImageItem>[].obs;
  var rxCategoryFilter = 'All'.obs;
  var rxSearchQuery = ''.obs;
  var rxIsLightTheme = false.obs;
  var isUploading = false.obs;

  // Pagination Variables
  DocumentSnapshot? _lastDocument;
  var hasMore = true.obs;
  var isLoadingMore = false.obs;
  final int _pageSize = 10;

  final searchController = TextEditingController();
  final scrollController = ScrollController();
  final _firebaseStorage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    // Load presets first so UI is not empty
    images.assignAll(ImageRepository.getInitialPresets());

    refreshAllData();

    searchController.addListener(() {
      rxSearchQuery.value = searchController.text;
    });


    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        fetchFirebaseImages();
      }
    });

    // Refresh when category changes
    ever(rxCategoryFilter, (_) => refreshAllData());
  }

  void refreshAllData() async {
    // Run sequentially to prevent race conditions during list assignment
    await fetchFirebaseImages(isRefresh: true);
    await fetchStorageImages();
  }

  Future<void> fetchStorageImages() async {
    final folders = ['animals', 'birds', 'nature'];
    print('LOG: Starting Storage fetch for folders: $folders');

    for (String folder in folders) {
      try {
        // Path as per screenshot: users/animals, users/birds, users/nature
        final ref = _firebaseStorage.ref().child('users/$folder');
        final result = await ref.listAll();

        print('LOG: Folder [$folder] contains ${result.items.length} files.');

        for (var item in result.items) {
          try {
            final url = await item.getDownloadURL();
            final metadata = await item.getMetadata();

            final category = folder[0].toUpperCase() + folder.substring(1);
            // More unique ID including folder name
            final id = 'storage_${folder}_${item.name}';

            if (!images.any((img) => img.id == id)) {
              images.add(ImageItem(
                id: id,
                title: item.name
                    .split('.')
                    .first
                    .replaceAll('_', ' ')
                    .replaceAll('-', ' ')
                    .toUpperCase(),
                description: 'Captured specimen in the $category section.',
                category: category,
                imageUrl: url,
                uploadDate: metadata.timeCreated?.toIso8601String() ??
                    DateTime.now().toIso8601String(),
                uploaderName: 'Sanctuary Admin',
                downloadsCount: 0,
                likesCount: 0,
                location: 'Sanctuary Reserve',
              ));
              print('LOG: Added Storage image: $folder/${item.name}');
            }
          } catch (innerE) {
            print('LOG: Error fetching details for ${item.name}: $innerE');
          }
        }
      } catch (e) {
        print('LOG: Error in fetchStorageImages for $folder: $e');
      }
    }
  }

  Future<void> fetchFirebaseImages({bool isRefresh = false}) async {
    if (isRefresh) {
      _lastDocument = null;
      hasMore.value = true;
    }

    if (!hasMore.value || isLoadingMore.value) return;

    isLoadingMore.value = true;

    try {
      Query query = FirebaseFirestore.instance
          .collection('all_user_images')
          .orderBy('uploadedAt', descending: true)
          .limit(_pageSize);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();

      if (snapshot.docs.length < _pageSize) {
        hasMore.value = false;
      }

      if (snapshot.docs.isNotEmpty) {
        _lastDocument = snapshot.docs.last;
      }

      final newImages = snapshot.docs.map((doc) {
        return ImageItem.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      if (isRefresh) {
        // Keep presets and refresh others
        images.assignAll(ImageRepository.getInitialPresets());
      }

      for (var img in newImages) {
        if (!images.any((existing) => existing.id == img.id)) {
          images.add(img);
        }
      }
    } catch (e) {
      print('LOG: Error fetching firebase images: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  List<ImageItem> get filteredImages {
    return images.where((img) {
      // Exclude internal sync backups
      final isNotSyncBackup = !img.imageUrl.contains('user_sync_backups');

      final categoryMatch = rxCategoryFilter.value == 'All' ||
          img.category.toLowerCase() == rxCategoryFilter.value.toLowerCase();

      final searchMatch = rxSearchQuery.value.isEmpty ||
          img.title.toLowerCase().contains(rxSearchQuery.value.toLowerCase()) ||
          img.location
              .toLowerCase()
              .contains(rxSearchQuery.value.toLowerCase());

      return isNotSyncBackup && categoryMatch && searchMatch;
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

  void toggleTheme() {
    rxIsLightTheme.value = !rxIsLightTheme.value;
    Get.changeThemeMode(
        rxIsLightTheme.value ? ThemeMode.light : ThemeMode.dark);
  }

  void resetData() {
    refreshAllData();
    AppToast.show('Refreshing sanctuary listings...');
  }
}
