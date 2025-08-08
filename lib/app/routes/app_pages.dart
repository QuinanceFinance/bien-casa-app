import 'package:bien_casa/app/controllers/auth_controller.dart';
import 'package:bien_casa/app/screens/auth/forgot_password_flow/forgot_password_screen.dart';
import 'package:bien_casa/app/screens/auth/signup_flow/passport_verification_screen.dart';
import 'package:bien_casa/app/screens/auth/signup_flow/kyc_success_screen.dart';
import 'package:bien_casa/app/screens/auth/forgot_password_flow/reset_password_screen.dart';
import 'package:bien_casa/app/screens/auth/signin_screen.dart';
import 'package:bien_casa/app/screens/auth/login_flow/signin_otp_verification_screen.dart';
import 'package:bien_casa/app/screens/user/user_home.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/welcome_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/auth/signup_flow/phone_verification_screen.dart';
import '../screens/auth/signup_flow/otp_verification_screen.dart';
import '../screens/auth/signup_flow/kyc_verification_screen.dart';
import '../screens/auth/signup_flow/nin_verification_screen.dart';
import '../screens/auth/signup_flow/nin_password_screen.dart';
import '../screens/auth/signup_flow/check_readability_screen.dart';
import '../screens/auth/signup_flow/check_quality_screen.dart';
import '../screens/auth/signup_flow/address_verification_screen.dart';
import '../screens/user/widgets/home/search/search_screen.dart';
import '../screens/user/widgets/home/property/featured_properties_screen.dart';
import '../screens/user/widgets/home/property/recently_added_screen.dart';
import '../screens/user/widgets/home/property/location_properties_screen.dart';
import '../screens/user/widgets/home/property/property_detail_screen.dart';
import '../screens/auth/signup_flow/selfie_screen.dart';
import '../screens/auth/signup_flow/map_address_screen.dart';
import '../bindings/welcome_binding.dart';
import '../bindings/onboarding_binding.dart';
import '../bindings/user_home_binding.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.kycSuccess,
      page: () => const KYCSuccessScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.SIGNIN_OTP_VERIFICATION,
      page: () => SignInOtpVerificationScreen(phoneNumber: Get.arguments ?? ''),
      transition: Transition.rightToLeft,
    ),
    GetPage(name: AppRoutes.SPLASH, page: () => const SplashScreen()),
    GetPage(
      name: AppRoutes.ONBOARDING,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.WELCOME,
      page: () => const WelcomeScreen(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGNUP,
      page: () => const SignUpScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.SIGNIN,
      page: () => const SignInScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => AuthController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.REST_PASSWORD,
      page: () => const ResetPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.PHONE_VERIFICATION,
      page: () => PhoneVerificationScreen(userType: Get.arguments as String),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.OTP_VERIFICATION,
      page: () => OtpVerificationScreen(phoneNumber: Get.arguments as String),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.KYC_VERIFICATION,
      page: () => const KYCVerificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.NIN_VERIFICATION,
      page: () => const NINVerificationScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => AuthController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.PASSPORT_VERIFICATION,
      page: () => const PassportVerificationScreen(),
      binding: BindingsBuilder(() => Get.lazyPut(() => AuthController())),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.NIN_PASSWORD,
      page: () => const NINPasswordScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.CHECK_READABILITY,
      page: () => const CheckReadabilityScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.CHECK_QUALITY,
      page: () => CheckQualityScreen(image: Get.arguments as XFile),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.ADDRESS_VERIFICATION,
      page: () => const AddressVerificationScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.SELFIE,
      page: () => const SelfieScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.MAP_ADDRESS,
      page: () => const MapAddressScreen(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.USER_HOME,
      page: () => const UserHome(),
      binding: UserHomeBinding(),
      transition: Transition.rightToLeft,
    ),
    
    // New property-related screens
    GetPage(
      name: AppRoutes.SEARCH,
      page: () => const SearchScreen(),
      binding: UserHomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.FEATURED_PROPERTIES,
      page: () => FeaturedPropertiesScreen(),
      binding: UserHomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.RECENTLY_ADDED,
      page: () => RecentlyAddedScreen(),
      binding: UserHomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.LOCATION_PROPERTIES,
      page: () => LocationPropertiesScreen(),
      binding: UserHomeBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.PROPERTY_DETAIL,
      page: () => PropertyDetailScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
