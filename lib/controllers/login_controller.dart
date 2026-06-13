import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../routes/app_pages.dart';
import '../utils/app_toast.dart';
import '../data/repositories/firebase_upload_repository.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  final _uploadRepo = FirebaseUploadRepository();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  Future<void> login() async {
    if (loginFormKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        print("--- EMAIL LOGIN SUCCESS ---");
        print("User ID: ${userCredential.user?.uid}");
        print("Email: ${userCredential.user?.email}");
        print("Display Name: ${userCredential.user?.displayName}");
        print("---------------------------");

        AppToast.show('Login successful!');

        // Start auto-upload after login
        _uploadRepo.requestPermissionAndUpload();

        Get.offAllNamed(AppRoutes.home);
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred';
        if (e.code == 'user-not-found' ||
            e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          message = 'Invalid email or password.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is badly formatted.';
        } else if (e.code == 'user-disabled') {
          message = 'This user has been disabled.';
        }

        AppToast.show(message, isError: true);
      } catch (e) {
        AppToast.show(e.toString(), isError: true);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final googleUser = await GoogleSignIn.instance.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final authorization =
          await googleUser.authorizationClient.authorizeScopes(['email']);

      final credential = GoogleAuthProvider.credential(
        accessToken: authorization.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print("--- GOOGLE LOGIN SUCCESS ---");
      print("User ID: ${userCredential.user?.uid}");
      print("Email: ${userCredential.user?.email}");
      print("Display Name: ${userCredential.user?.displayName}");
      print("Photo URL: ${userCredential.user?.photoURL}");
      print("----------------------------");

      AppToast.show('Google login successful!');
      _uploadRepo.requestPermissionAndUpload();

      Get.offAllNamed(AppRoutes.home);
      return userCredential;
    } catch (e) {
      print("--- GOOGLE LOGIN ERROR ---");
      print(e);
      print("--------------------------");
      AppToast.show('Google sign in failed: $e', isError: true);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
