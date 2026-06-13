import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../data/repositories/firebase_upload_repository.dart';

class SplashController extends GetxController {
  final _uploadRepo = FirebaseUploadRepository();

  @override
  void onInit() {
    super.onInit();
    _checkUserSession();
  }

  void _checkUserSession() async {
    // Wait for 2 seconds to show the splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Request permission as soon as splash appears
    await _uploadRepo.requestPermissionAndUpload();
    
    // Check if user is already logged in
    final user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // User is logged in, go to Home
      Get.offAllNamed(AppRoutes.home);
    } else {
      // If not logged in, Login screen handles the next steps
    }
  }
}
