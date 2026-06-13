import 'dart:io';
import 'package:WelcomeGoats/controllers/register_controller.dart';
import 'package:WelcomeGoats/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_images.dart';
import '../../utils/colors.dart';
import '../../utils/common_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.backgroundImage),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: controller.registerFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 80),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              width: 1.5),
                        ),
                        child: const Icon(
                          Icons.person_add_rounded,
                          color: AppColors.primaryLight,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'CREATE ACCOUNT',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Join our wildlife exploration community',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.borderLight.withValues(alpha: 20),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  /// registration card
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 18),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: const Color(0xFF111111).withValues(alpha: .70),
                        border: Border.all(
                            width: 1, color: const Color(0xff2d2e2d)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: .50),
                              offset: const Offset(0, 20),
                              spreadRadius: 12,
                              blurRadius: 12)
                        ]),
                    child: Column(
                      children: [
                        /// Profile Image Section
                        GestureDetector(
                          onTap: controller.pickImage,
                          child: Obx(
                            () => Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: .2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: const Color(0xff2d2e2d), width: 2),
                                image: controller.selectedImagePath.value.isNotEmpty
                                    ? DecorationImage(
                                        image: FileImage(
                                            File(controller.selectedImagePath.value)),
                                        fit: BoxFit.cover)
                                    : null,
                              ),
                              child: controller.selectedImagePath.value.isEmpty
                                  ? const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Color(0xff0e9169),
                                      size: 40,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Upload Profile Photo',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Name text field
                        TextFormField(
                          controller: controller.nameController,
                          validator: controller.validateName,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 13.0, horizontal: 16.0),
                              filled: true,
                              fillColor: Colors.black.withValues(alpha: .05),
                              prefixIcon: const Icon(
                                Icons.person,
                                size: 20,
                                color: Color(0xff0e9169),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xff2d2e2d))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xff2d2e2d))),
                              hintText: 'Full Name',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xff2d2e2d)))),
                        ),
                        const SizedBox(height: 16),

                        /// email text field
                        TextFormField(
                          controller: controller.emailController,
                          validator: controller.validateEmail,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 13.0, horizontal: 16.0),
                              filled: true,
                              fillColor: Colors.black.withValues(alpha: .05),
                              prefixIcon: const Icon(
                                Icons.email,
                                size: 20,
                                color: Color(0xff0e9169),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xff2d2e2d))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xff2d2e2d))),
                              hintText: 'Email Address',
                              hintStyle: const TextStyle(color: Colors.grey),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      width: 1, color: Color(0xff2d2e2d)))),
                        ),
                        const SizedBox(height: 16),

                        // Password TextF
                        Obx(
                          () => TextFormField(
                            controller: controller.passwordController,
                            validator: controller.validatePassword,
                            obscureText: !controller.isPasswordVisible.value,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 13.0, horizontal: 16.0),
                                filled: true,
                                fillColor: Colors.black.withValues(alpha: .05),
                                prefixIcon: const Icon(
                                  Icons.lock,
                                  size: 20,
                                  color: Color(0xff0e9169),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed:
                                      controller.togglePasswordVisibility,
                                ),
                                hintText: 'Enter Password',
                                hintStyle: const TextStyle(color: Colors.grey),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xff2d2e2d))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xff2d2e2d))),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xff2d2e2d)))),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Obx(
                          () => CommonButton(
                            onTap: controller.signUp,
                            title: "CREATE ACCOUNT",
                            isLoading: controller.isLoading.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: const Color(0xFF111111).withValues(alpha: .30),
                          border: Border.all(
                              width: 1, color: const Color(0xff2d2e2d)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: .50),
                                offset: const Offset(0, 20),
                                spreadRadius: 12,
                                blurRadius: 12)
                          ]),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: AppColors.textLightSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Login Now",
                                    style: TextStyle(
                                      color: AppColors.primaryLight,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 2),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                    color: AppColors.primaryLight,
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
