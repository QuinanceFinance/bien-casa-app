import 'package:get/get.dart';
import '../controllers/flatmate_controller.dart';

class FlatmateBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FlatmateController());
  }
}
