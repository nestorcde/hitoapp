import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/utils/constants.dart';
import 'package:hito_app/app/modules/profile/profile_controller.dart';
import 'package:hito_app/app/modules/usuario/usuarios_controller.dart';
import 'package:hito_app/app/ui/widgets/boton_azul.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/custom_input.dart';

class ProfilePage extends GetView<ProfileController> {
  final UsuarioController _usuarioController = Get.find<UsuarioController>();
  final width = Get.size.width;

  @override
  Widget build(BuildContext context) {
    //const imagen = '';

    final usuario = _usuarioController.usuarioProfile.value;
    // final nombreController = TextEditingController();
    // final telefonoController = TextEditingController();
    final tipoController = TextEditingController();
    controller.usuarioObs = usuario.obs;
    controller.nombreController.value.text = usuario.nombre;
    controller.idUsuarioController.value.text = usuario.idUsuario;
    controller.tipoValue.value = usuario.tipo;
    TipoUsuario? _tipoUsuario = TipoUsuario.Administrador;
     // Initial Selected Value
    String dropdownvalue = 'OPER';  

    // List of items in our dropdown menu
    var items = [   
      'ADMIN',
      'OPER'
    ];
    return Scaffold(
        appBar: customAppBar('Perfil',true),
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
                      'Informacion Personal:',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () => controller.resetPassword(),
                      icon: const Icon(Icons.key),
                      tooltip: 'Resetear password',
                      
                    ),
                    IconButton(
                      onPressed: () => controller.activarEdicion(),
                      icon: const Icon(Icons.edit),
                      tooltip: 'Editar Informacion Personal',

                    )
                  ],
                ),
              ),
              Obx(() => CustomInput(
                    icon: Icons.account_circle_outlined,
                    enabled: controller.editIdUsuario.value,
                    placeholder: 'ID USUARIO',
                    textController: controller.idUsuarioController.value,
                    onChanged: controller.nomOnChange,
                  )),
              Obx(() => CustomInput(
                    icon: Icons.account_circle_outlined,
                    enabled: controller.editNombre.value,
                    placeholder: 'nombre',
                    textController: controller.nombreController.value,
                    onChanged: controller.nomOnChange,
                  )),
                const ListTile( title: Text("Tipo de Usuario"),),
              Obx(() => 
               ListTile(
                    title: const Text("Administrador"),
                    leading:  Radio<String>(
                      value: "ADMIN",
                      groupValue: controller.tipoValue.value,
                      onChanged: (value) {
                        if(controller.editTipo.value)controller.tipoValue.value = value!;
                      },
                      toggleable: controller.editTipo.value,
                    ),
                  )),
              Obx(() => ListTile(
                    title: const Text("Operador"),
                    leading:  Radio<String>(
                      value: "OPER",
                      groupValue: controller.tipoValue.value,
                      onChanged: (value) {
                        if(controller.editTipo.value)controller.tipoValue.value = value!;
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
                          }),
                    ),
                  ))
            ],
          ),
        ))));
  }
}
