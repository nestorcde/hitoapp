



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/modules/usuario/usuarios_controller.dart';
import 'package:hito_app/app/routes/routes_app.dart';

PreferredSizeWidget customAppBar(String nombre, bool volver ){
  UsuarioController _usuarioController = Get.find<UsuarioController>();
  return AppBar(
              title: Text(
                nombre,
                style: const TextStyle(color: Colors.black87),
              ),
              centerTitle: true,
              elevation: 1,
              backgroundColor: Colors.white,
              leading: volver?IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black,), onPressed: () => Get.back()):const SizedBox(),
              actions: [
                IconButton(
                  onPressed: () async {
                    //_usuarioController.disconnect();
                    await _usuarioController.deleteToken();
                    Get.offNamed(Routes.LOGIN);
                  },
                  color: Colors.black87,
                  icon: const Icon(Icons.exit_to_app)),
              ],
              // leading: IconButton(
              //     onPressed: () async {
              //       //_usuarioController.disconnect();
              //       await _usuarioController.deleteToken();
              //       Get.offNamed(Routes.LOGIN);
              //     },
              //     color: Colors.black87,
              //     icon: const Icon(Icons.exit_to_app)),
              // actions: [
              //    Container(
              //         margin: const EdgeInsets.only(right: 10),
              //         child: Obx(() => _socketProvider.serverStatus.value == ServerStatus.Online
              //             ? Icon(
              //                 Icons.check_circle,
              //                 color: Colors.blue[400],
              //               )
              //             : const Icon(
              //                 Icons.offline_bolt,
              //                 color: Colors.red,
              //               ),
              //       ))
              // ],
            );
}