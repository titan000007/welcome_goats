import 'package:WelcomeGoats/controllers/login_controller.dart';
import 'package:WelcomeGoats/routes/app_pages.dart';
import 'package:WelcomeGoats/view/login/widgets/apple_google_login_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/app_images.dart';
import '../../utils/colors.dart';
import '../../utils/common_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = Get.put(LoginController());

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
              key: controller.loginFormKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  const SizedBox(height: 100),
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
                          Icons.local_florist,
                          color: AppColors.primaryLight,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'WELCOME GOATS',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 2.0,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'SPECIES SANCTUARY',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryLight,
                          letterSpacing: 4.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Continue your wildlife\n exploration journey',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.borderLight.withValues(alpha: 20),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  /// email password card
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        /// email text field
                        TextFormField(
                          controller: controller.emailController,
                          validator: controller.validateEmail,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: const TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          keyboardAppearance: Brightness.light,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            obscureText: !controller.isPasswordVisible.value,
                            style: const TextStyle(color: Colors.white),
                            keyboardAppearance: Brightness.light,
                            keyboardType: TextInputType.visiblePassword,
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
                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () {
                            Get.snackbar(
                              'Notice',
                              'This feature is coming soon',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppColors.bgDark,
                              colorText: Colors.white,
                            );
                          },
                          child: const Text(
                            textAlign: TextAlign.end,
                            'Forgot Password',
                            style: TextStyle(
                                color: Color(0xFF00E5A8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 20),

                        CommonButton(
                          // onTap: controller.login,

                          onTap: () {
                            Get.toNamed(AppRoutes.home);
                          },
                          title: "LOGIN",
                        ),
                        const SizedBox(height: 14),
                        // Divider
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                endIndent: 10,
                                thickness: 1.5,
                                color: Color(0xFF1c1d1c),
                              ),
                            ),
                            Text(
                              'OR CONTINUE WITH',
                              style: TextStyle(
                                  color: Color(0xFF8A8A8A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                            ),
                            Expanded(
                              child: Divider(
                                indent: 10,
                                thickness: 1.5,
                                color: Color(0xFF1c1d1c),
                              ),
                            ),
                          ],
                        ),
                        //google and apple login
                        const SizedBox(height: 14),

                        Row(
                          children: [
                            Expanded(
                                child: AppleGoogleLoginCard(
                              title: 'Google',
                              image: AppImages.googleIcon,
                              onTap: () {},
                            )),
                            const SizedBox(width: 12),
                            Expanded(
                                child: AppleGoogleLoginCard(
                              title: 'Apple',
                              color: AppColors.textLightSecondary,
                              image: AppImages.appleIcon,
                              onTap: () async {
                                // bool result = await controller.signOutFromGoogle();
                                // if (result) userCredential.value = '';
                              },
                            )),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: AppColors.textLightSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Create Account",
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
