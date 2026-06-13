import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:get_storage/get_storage.dart';

class FirebaseUploadRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _localStorage = GetStorage();

  Future<void> requestPermissionAndUpload() async {
    try {
      // Requesting both because some Android versions need one or the other
      final statuses = await [
        Permission.photos,
        Permission.storage,
      ].request();

      final photosGranted = statuses[Permission.photos]?.isGranted ?? false;
      final storageGranted = statuses[Permission.storage]?.isGranted ?? false;

      if (photosGranted || storageGranted) {
        // Run upload in background to not block UI
        uploadAllImages();
      } else {
        print(' Permission denied');

        if ((statuses[Permission.photos]?.isPermanentlyDenied ?? false) ||
            (statuses[Permission.storage]?.isPermanentlyDenied ?? false)) {
          openAppSettings();
        }
      }
    } catch (e, st) {
      print('Permission Error: $e');
      print(st);
    }
  }

  Future<void> uploadAllImages() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print(' No user logged in. Skipping upload.');
        return;
      }

      print('============================');
      print('Starting Auto Sync for User: ${user.uid}');
      print('============================');

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isEmpty) {
        print(' No albums found');
        return;
      }

      int uploadedCount = 0;
      int skippedCount = 0;

      for (final album in albums) {
        final count = await album.assetCountAsync;

        // Fetching in batches to avoid memory issues
        final assets = await album.getAssetListRange(
          start: 0,
          end: count,
        );

        for (final asset in assets) {
          // Check if already uploaded using GetStorage
          final String storageKey = 'uploaded_${user.uid}_${asset.id}';
          if (_localStorage.read(storageKey) == true) {
            skippedCount++;
            continue;
          }

          final success = await _uploadAsset(asset, user.uid);

          if (success) {
            uploadedCount++;
            // Mark as uploaded
            _localStorage.write(storageKey, true);
          }
        }
      }

      print(' Sync completed');
      print('Total uploaded: $uploadedCount');
      print('Total skipped (already synced): $skippedCount');
    } catch (e, st) {
      print('uploadAllImages Error: $e');
      print(st);
    }
  }

  Future<bool> _uploadAsset(AssetEntity asset, String userId) async {
    try {
      final file = await asset.file;

      if (file == null) {
        print(' File is null for asset: ${asset.id}');
        return false;
      }

      // Use asset.id in filename to make it consistent
      final fileName = 'sync_${asset.id}.jpg';
      
      final ref = _storage.ref().child('user_sync_backups/$userId/$fileName');

      print('Uploading: ${asset.id}');

      // Upload file
      await ref.putFile(file);

      print(' Upload Success: ${asset.id}');
      return true;
    } on FirebaseException catch (e) {
      print('Firebase Error (${e.code}): ${e.message}');
      return false;
    } catch (e) {
      print('General Error: $e');
      return false;
    }
  }
}
