import 'package:get/get.dart';
import '../routes/app_routes.dart';

class WelcomeController extends GetxController {
  void navigateToSignUp() {
    Get.toNamed(AppRoutes.SIGNUP);
  }

  void navigateToSignIn() {
    Get.toNamed(AppRoutes.SIGNIN);
  }
}
