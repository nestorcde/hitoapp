


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/modules/profile/profile_controller.dart';

Future dialogoTurno(String titulo, String content, bool conFuncion, String boton, Function funcion) =>Get.dialog(
                            AlertDialog(
                              title:  Text(titulo),
                              content: Text(content),
                              actions: [
                                TextButton(onPressed: Get.back, child: const Text('Cancelar')),
                                conFuncion? TextButton(onPressed: (){funcion(); Get.back();}, child:  Text(boton)):const SizedBox()
                              ],
                            )
                          );

Future dialogoOtro(TextEditingController controller, String horario, Rx<DateTime> diaEnfocado, Function funcion) =>Get.dialog(
      AlertDialog(
        title:  Text('Registro'),
        content: Text('Ingrese el nombre de la persona a la que desea agendar'),
        actions: [
          TextField(controller: controller,),
          TextButton(onPressed: (){
            if(controller.text.isNotEmpty){
              funcion(diaEnfocado.value,horario,controller.text); 
              Get.back();
            }else{
              Get.snackbar('Falta Nombre', 'Ingrese nombre de la persona a la que agendaar');
            }
          }, child:  Text('OK'))
        ],
      )
    );

Future dialogoTuto(String titulo, String content, String boton, Function funcion) =>Get.dialog(
  AlertDialog(
    title:  Text(titulo),
    content: Text(content),
    actions: [
      TextButton(onPressed: (){funcion(); Get.back();}, child:  Text(boton))
    ],
  )
);

Future dialogoConsulta(String titulo, String content, String boton1,String boton2, ProfileController profileController) =>Get.dialog(
  AlertDialog(
    title:  Text(titulo),
    content: Text(content),
    actions: [
      TextButton(onPressed: (){profileController.confirmarCambioPsw(true); Get.back();}, child:  Text(boton1)),
      TextButton(onPressed: (){profileController.confirmarCambioPsw(false); Get.back();}, child:  Text(boton2))
    ],
  )
);

Future dialogoConsulta2(String titulo, String content, String boton1,String boton2, Function funcion) =>Get.dialog(
  AlertDialog(
    title:  Text(titulo),
    content: Text(content),
    actions: [
      TextButton(onPressed: ()=>funcion(0), child:  Text(boton1)),
      TextButton(onPressed: () => Get.back(), child:  Text(boton2))
    ],
  )
);