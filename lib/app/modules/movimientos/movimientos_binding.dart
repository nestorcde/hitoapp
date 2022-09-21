import 'package:get/get.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_controller.dart';

class MovimientosBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<MovimientosController>(() => MovimientosController());
  }
}