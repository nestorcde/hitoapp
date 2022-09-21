import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hito_app/app/modules/paises/paises_controller.dart';
import 'package:hito_app/app/utils/constants.dart';
import 'package:hito_app/app/modules/profile/profile_controller.dart';
import 'package:hito_app/app/ui/widgets/boton_azul.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/custom_input.dart';

class PaisPage extends GetView<PaisesController> {
  final width = Get.size.width;

  @override
  Widget build(BuildContext context) {
    //const imagen = '';

    final paises = controller.paisSelected.value;
    controller.idPaisSelected.value = paises.idPais;
    controller.idPaisCtrl.value.text = paises.idPais.toString();
    controller.nombreCtrl.value.text = paises.nombre;
    controller.mercosurSelected.value = paises.mercosur;

    return Scaffold(
        appBar: customAppBar('Pais',true),
        body: SafeArea(
            child: Center(
                child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Informacion del Pais:',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => controller.activarEdicion(),
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar Informacion del Pais',

                    )
                  ],
                ),
              ),
              Obx(() => CustomInput(
                    icon: Icons.account_circle_outlined,
                    enabled: false,
                    placeholder: 'codigo',
                    textController: controller.idPaisCtrl.value,
                    onChanged: (){},
                  )),
              Obx(() => CustomInput(
                    icon: Icons.account_circle_outlined,
                    enabled: controller.editNombre.value,
                    placeholder: 'nombre',
                    textController: controller.nombreCtrl.value,
                    onChanged: controller.nombreOnChange,
                  )),
                const ListTile( title: Text("Mercosur"),),
              Obx(() => 
               ListTile(
                    title: const Text("SI"),
                    leading:  Radio<bool>(
                      value: true,
                      groupValue: controller.mercosurSelected.value,
                      onChanged: (value) {
                        if(controller.editMercosur.value){
                          controller.mercosurSelected.value = value!;
                          controller.mercosurOnChange(value);
                        };
                      },
                      toggleable: controller.editMercosur.value,
                    ),
                  )),
              Obx(() => ListTile(
                    title: const Text("NO"),
                    leading:  Radio<bool>(
                      value: false,
                      groupValue: controller.mercosurSelected.value,
                      onChanged: (value) {
                        if(controller.editMercosur.value){
                          controller.mercosurSelected.value = value!;
                          controller.mercosurOnChange(value);
                        };
                      },

                    ),
                  )),
                  
              // CustomInput(
              //       icon: Icons.email_outlined,
              //       enabled: controller.editTipo.value,
              //       placeholder: 'tipo',
              //       textController: controller.tipoController.value,
              //       onChanged: controller.tipoOnChange,
              //     )
              Obx(() => Visibility(
                    visible: controller.verBtnGuardar.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: BotonAzul(
                          texto: 'Guardar Datos',
                          autenticando: controller
                              .guardando.value, //authService.autenticando,
                          funcion: () {
                            FocusScope.of(context).unfocus();
                            controller.guardarDatos();
                            Get.back();
                          }),
                    ),
                  ))
            ],
          ),
        ))));
  }
}
