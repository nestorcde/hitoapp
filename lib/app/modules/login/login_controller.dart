import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/data/repository/remote/auth_repository.dart';
import 'package:hito_app/app/routes/routes_app.dart';


class LoginController extends GetxController {
  final AuthRepository repository = Get.find<AuthRepository>();
  //final LandingController landingController = Get.find<LandingController>();

  RxBool loginOk = false.obs;
  RxBool autenticando = false.obs;
  RxString idUsuario = ''.obs, password = ''.obs;
  RxString newPassword1 = ''.obs, newPassword2 = ''.obs;

  pswOnChange(String text){
    password.value = text;
  }

  idUsuarioOnChange(String text){
    idUsuario.value = text;
  }
  
  newPsw1OnChange(String text){
    newPassword1.value = text;
  }

  newPsw2OnChange(String text){
    newPassword2.value = text;
  }

  void changepassword()async{
    if(verificado(newPassword1.value, newPassword2.value)){
      if(newPassword1.value==newPassword2.value){
        http.Response resp = await repository.changePassword(repository.usuario.idUsuario, newPassword1.value);
        final response = jsonDecode(resp.body);
        //print(response);
        if(response["ok"]){
          repository.usuarioAuth = Usuarios.fromJson(response["usuarios"]);
          Get.dialog(
              AlertDialog(
              title: const Text('Procedimiento Exitoso'),
              content: const Text('Contraseña establecida correctamente.'),
                actions: [TextButton(onPressed: ()=> repository.usuario.tipo=="ADMIN"?
                                                      Get.offAllNamed(Routes.HOME):
                                                      Get.offAllNamed(Routes.HOMEOPER), 
                                                      child: const Text('OK'))],
            )
          );
        }else{
          Get.dialog(
              AlertDialog(
              title: const Text('Error'),
              content:  Text(response["msg"]),
                actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
            )
          );
        }
      }else{
        Get.dialog(
            AlertDialog(
            title: const Text('Error'),
            content: const Text('Los campos no coinciden'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
          )
        );
      }
    }else{
      Get.dialog(
          AlertDialog(
          title: const Text('Error'),
          content: const Text('Todos los campos son obligatorios'),
            actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
        )
      );
    }
  }

  void login() async {
    if(verificado(idUsuario.value, password.value)){
      
      autenticando.value = true;
      //FocusScope.of(context).unfocus();
      try {
        loginOk.value = await repository.login(idUsuario.value.trim(), password.value.trim()); 
        
        if(loginOk.value){
          autenticando.value = false;
          //Get.offNamed(Routes.LANDING);
          repository.usuario.chPassword?
            Get.offAllNamed(Routes.CHANGEPASSWORD)
          :
            repository.usuario.tipo=="ADMIN"?
            Get.offAllNamed(Routes.HOME):
            Get.offAllNamed(Routes.HOMEOPER);
        }else{
          autenticando.value = false;
          Get.dialog(
             AlertDialog(
              title: const Text('Login Incorrecto'),
              content: const Text('Usuario o Contraseña incorrectas'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
            )
          );
        }
      } on HttpException catch(e){
          print(e.message);
          autenticando.value = false;
          Get.dialog(
             AlertDialog(
              title: const Text('Login Incorrecto'),
              content: Text('Error de Red: ${e.message}'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
            )
          );
      } on Exception catch(er){
          print(er.toString());
          autenticando.value = false;
          Get.dialog(
             AlertDialog(
              title: const Text('Login Incorrecto'),
              content: Text('Error de Red: ${er.toString()}'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
            )
          );
      }
    }else{
        autenticando.value = false;
        Get.dialog(
           AlertDialog(
            title: const Text('Login Incorrecto'),
            content: const Text('idUsuario y password obligatorios'),
              actions: [TextButton(onPressed: Get.back, child: const Text('OK'))],
          )
        );
    }

    

  }

  bool  verificado(String idUsuario, String password) {
    if(idUsuario == '' || password == '') return false;
      
      return true;
  }
}