import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'utils/nature_theme.dart';
import 'routes/app_pages.dart';
import 'controllers/gallery_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await GoogleSignIn.instance.initialize();

  runApp(const WelcomeGoatsApp());
}

class WelcomeGoatsApp extends StatelessWidget {
  const WelcomeGoatsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Welcome Goats',
      debugShowCheckedModeBanner: false,
      theme: NatureTheme.light,
      darkTheme: NatureTheme.dark,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
    );
  }
}
