import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/data/repository/local/local_auth_repository.dart';
import 'package:hito_app/app/data/repository/remote/auth_repository.dart';
import 'package:hito_app/app/modules/usuario/usuarios_repository.dart';
import 'package:hito_app/app/utils/constants.dart';



class UsuarioController extends GetxController {
  late LocalAuthRepository _localAuthRepository;
  late AuthRepository _authRepository;
  late UsuarioRepository _usuarioRepository;

  RxList usuarios = [].obs;
  //ServerStatus get serverStatus => _socketRepository.serverStatus;

  Future<void> deleteToken() async{
    await _localAuthRepository.deleteToken();
  }

  Usuarios get usuario => _authRepository.usuario;

  Usuarios usuarioDefault = Usuarios(idUsuario: "", nombre: "", tipo: "", uid: "", chPassword: true);

  Rx<Usuarios> usuarioProfile = Usuarios(idUsuario: "", nombre: "", tipo: "", uid: "", chPassword: true).obs;

  Future<List<Usuarios>> getAllUsuarios()  =>  _usuarioRepository.getUsuarios();

  setTuto() async =>_usuarioRepository.setTuto(usuario.uid);

  Rx<ServerStatus>  estado = ServerStatus.Connecting.obs;



  cargarUsuarios() async{
      usuarios.value = await _usuarioRepository.getUsuarios();
      update();
  }
  

  void disconnect(){
    //_socketRepository.disconnect();
  }
  
  @override
  void onInit() {
    super.onInit();
    _localAuthRepository = Get.find<LocalAuthRepository>();
    _authRepository = Get.find<AuthRepository>();
    _usuarioRepository = Get.find<UsuarioRepository>();
  }

  @override
  void onReady() async {
    super.onReady();
    cargarUsuarios();
  }

  @override
  void onClose() {
    super.onClose();
  }

}