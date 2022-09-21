import 'package:get/get.dart';
import 'package:hito_app/app/modules/home/controllers/home.controller.dart';

class HomeBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<HomeController>(() => HomeController());
  }
}