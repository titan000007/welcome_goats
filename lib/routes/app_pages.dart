import 'package:get/get.dart';

import '../view/details/image_details_view.dart';
import '../view/home/home_view.dart';
import '../view/login/login_screen.dart';
import '../view/my_uploads/my_uploads_view.dart';
import '../view/profile/profile_view.dart';
import '../view/splash/splash_view.dart';
import '../view/upload/upload_view.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const home = '/home';
  static const upload = '/upload';
  static const details = '/details';
  static const myUploads = '/my-uploads';
  static const profile = '/profile';
}

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
    ),
    GetPage(
      name: AppRoutes.upload,
      page: () => const UploadView(),
    ),
    GetPage(
      name: AppRoutes.details,
      page: () => ImageDetailsView(),
    ),
    GetPage(
      name: AppRoutes.myUploads,
      page: () => MyUploadsView(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
    ),
  ];
}
