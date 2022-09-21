import 'package:get/get.dart';
import 'controllers/home_oper.controller.dart';

class HomeOperBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<HomeOperController>(() => HomeOperController());
  }
}