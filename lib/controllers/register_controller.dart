import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../routes/app_pages.dart';
import '../utils/app_toast.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final registerFormKey = GlobalKey<FormState>();

  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final selectedImagePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      AppToast.show('Failed to pick image: $e', isError: true);
    }
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
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
    return null;
  }

  Future<void> signUp() async {
    if (registerFormKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        String? photoUrl;
        if (selectedImagePath.value.isNotEmpty) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_profiles')
              .child('${userCredential.user!.uid}.jpg');

          await ref.putFile(File(selectedImagePath.value));
          photoUrl = await ref.getDownloadURL();
        }

        // Update display name and photo URL
        await userCredential.user
            ?.updateDisplayName(nameController.text.trim());
        if (photoUrl != null) {
          await userCredential.user?.updatePhotoURL(photoUrl);
        }

        AppToast.show('Account created successfully!');

        Get.offAllNamed(AppRoutes.home);
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred';
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        }

        AppToast.show(message, isError: true);
      } catch (e) {
        AppToast.show(e.toString(), isError: true);
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
