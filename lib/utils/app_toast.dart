import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppToast {
  static void show(String message, {bool isError = false}) {
    Get.rawSnackbar(
      messageText: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: isError
          ? Colors.red.withValues(alpha: 0.9)
          : const Color(0xFF111111).withValues(alpha: 0.9),
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 40),
      borderRadius: 25,
      duration: const Duration(seconds: 2),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
