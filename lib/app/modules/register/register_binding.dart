import 'package:get/get.dart';
import 'package:hito_app/app/modules/register/register_controller.dart';

class RegisterBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<RegisterController>(() => RegisterController());
  }
}