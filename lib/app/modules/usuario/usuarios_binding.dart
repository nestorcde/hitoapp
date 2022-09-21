import 'package:get/get.dart';
import 'package:hito_app/app/modules/usuario/usuarios_controller.dart';

class UsuarioBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<UsuarioController>(() => UsuarioController());
  }
}