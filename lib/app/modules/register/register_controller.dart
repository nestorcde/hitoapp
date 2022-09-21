import 'package:get/get.dart';

import 'package:hito_app/app/data/repository/remote/auth_repository.dart';
import 'package:hito_app/app/routes/routes_app.dart';

class RegisterController extends GetxController {

  final authRepository = Get.find<AuthRepository>();

  RxBool autenticando = false.obs;
  RxString idUsuario = ''.obs, email = ''.obs, tipo = ''.obs, nombre = ''.obs;

  usrOnChange(String text){
    idUsuario.value = text;
  }

  nombreOnChange(String text) {
    nombre.value = text;
  }

  tipoOnChange(String text){
    tipo.value = text;
  }

  emailOnChange(String text){
    email.value = text;
  }

  Future register() async {
    final registroOk = await authRepository.signIn(idUsuario.value.trim(), nombre.value.trim(), idUsuario.value.trim(), tipo.value.trim());

    if(registroOk == true){
      Get.back();
      //Get.offNamed(Routes.USUARIO);
    }else{
      Get.snackbar('Registro Incorrecto', registroOk);
      //mostrarAlerta(context, 'Registro incorrecto', registroOk);
    }
  }

  
}