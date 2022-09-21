
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/ui/widgets/dialogo_turno.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/data/provider/remote/auth_provider.dart';
import 'package:hito_app/app/modules/profile/profile_repository.dart';
import 'package:hito_app/app/modules/profile/profile_response_model.dart';
import 'package:hito_app/app/modules/usuario/usuarios_controller.dart';
import 'package:hito_app/app/utils/constants.dart';

import '../../ui/widgets/mostrar_alerta.dart';

class ProfileController extends GetxController {
  ProfileRepository repository = Get.find<ProfileRepository>();
  UsuarioController usuarioController = Get.find<UsuarioController>();

  final AuthProvider authProvider = Get.find<AuthProvider>();

  Rx<TextEditingController> nombreController = TextEditingController().obs;
  Rx<TextEditingController> idUsuarioController = TextEditingController().obs;
  RxString tipoValue = "".obs;
  RxBool confirmarCambioPsw = false.obs;

  late Rx<NetworkImage> profileImage ;

  //Usuario get usuario => repository.usuario;
  late Rx<Usuarios> usuarioObs;
  RxBool editNombre = false.obs;
  RxBool editTipo = false.obs;
  RxBool editIdUsuario = false.obs;
  RxBool verBtnGuardar = false.obs;
  RxBool guardando = false.obs;
  

  RxString nombre = ''.obs, telefono = ''.obs, tipo = ''.obs;
  var isLoading = false.obs;
  var imageURL = '';
  var url = Platform.isAndroid
        ? Constants.SOCKET_BASE_URL_ANDROID_LOCAL + '/uploads/'
        : Constants.SOCKET_BASE_URL_IOS_LOCAL + '/uploads/';
       
  

  nomOnChange(String text) {
    nombre.value = text;
  }

  telOnChange(String text) {
    telefono.value = text;
  }

  tipoOnChange(String tipoPrm) {
    
    tipo.value = tipoPrm;
    print(tipo.value);
    update();
  }

  void activarEdicion() {
    editNombre.value = true;
    editIdUsuario.value = true;
    editTipo.value = true;
    verBtnGuardar.value = true;
    update();
  }

  void desactivarEdicion() {
    editNombre.value = false;
    editIdUsuario.value = false;
    editTipo.value = false;
    verBtnGuardar.value = false;
    update();
  }

  Future<ProfileResponseModel> guardarDatos() async {
    // guardando.value = true;
    // usuarioObs = usuarioController.usuarioProfile.value.obs;
    // repository.updateProfile(
    //     idUsuarioController.value.text,
    //     nombreController.value.text,
    //     usuarioObs.value,
    //     tipoValue.value).then((value){
    //       authProvider.usuario = value;
    //       nombreController.value.text = value.nombre;
    //       desactivarEdicion();
    //       guardando.value = false;

    //     });

    if(idUsuarioController.value.text == "" || nombreController.value.text == ""){
        await mostrarAlerta(Get.context!, 'Error de Campos obligatorios', 'Todos los campos son obligatorios');
          idUsuarioController.value.text = usuarioController.usuarioProfile.value.idUsuario;
          nombreController.value.text = usuarioController.usuarioProfile.value.nombre;
          tipoValue.value = usuarioController.usuarioProfile.value.tipo;
        desactivarEdicion();
        return ProfileResponseModel(ok: false, msg: 'msg', usuarios: usuarioController.usuarioProfile.value);
    }else{
      usuarioController.usuarioProfile.value.idUsuario = idUsuarioController.value.text;
      usuarioController.usuarioProfile.value.nombre = nombreController.value.text;
      usuarioController.usuarioProfile.value.tipo = tipoValue.value;
      final http.Response response = await repository.updateProfile(
        idUsuarioController.value.text,
        nombreController.value.text,
        usuarioObs.value,
        tipoValue.value);
      if(response.statusCode==200){
        ProfileResponseModel profileResponseModel = profileRequestModelFromJson(response.body);
        if(profileResponseModel.ok){
          usuarioController.usuarioProfile.value = profileResponseModel.usuarios;
          nombreController.value.text = profileResponseModel.usuarios.nombre;
          idUsuarioController.value.text = profileResponseModel.usuarios.idUsuario;
          desactivarEdicion();
        // }else{
        //   usuarioController.usuarioProfile.value = usuarioController.usuarioDefault;
        //   prLocalCtrl.value.text = "";
        //   prExtrCtrl.value.text = "";
        //   desactivarEdicion();
        }
        return profileResponseModel;
      }else{
        await mostrarAlerta(Get.context!, 'Error de servidor', 'Comuniquese con el Administrador Error: ${response.body}');
          nombreController.value.text = usuarioController.usuarioProfile.value.nombre;
          idUsuarioController.value.text = usuarioController.usuarioProfile.value.idUsuario;
        desactivarEdicion();
        return ProfileResponseModel(ok: false, msg: 'msg', usuarios: usuarioController.usuarioProfile.value);
      }
    }
  }

  void resetPassword()async{
    await dialogoConsulta("Resetear Contraseña?", "Desea Resetear la contraseña?", "SI", "NO", this);
    if(confirmarCambioPsw.value)  await repository.resetPassword(usuarioController.usuarioProfile);
  }

  void actualizarPage() {
    update();
  }

  void modConfirmarCambioPsw(bool trueFalse){
    confirmarCambioPsw.value = trueFalse;
  }


}
