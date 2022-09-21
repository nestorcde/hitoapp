import 'package:get/get.dart';
import 'package:hito_app/app/modules/paises/paises_controller.dart';

class PaisesBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<PaisesController>(() => PaisesController());
  }
}