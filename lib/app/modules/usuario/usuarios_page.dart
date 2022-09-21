
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/modules/usuario/usuarios_controller.dart';
import 'package:hito_app/app/routes/routes_app.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/dialogo_turno.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  // final usuarioService = new UsuarioService();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuarios> usuarios = [];
  late UsuarioController usuarioController;
  var indicador = 1;

  @override
  void initState() {
    usuarioController = Get.find<UsuarioController>();
    usuarioController.cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    // final usuario = authService.usuario;
    return GetBuilder<UsuarioController>(
      builder: (_) {
        
        return Scaffold(
            appBar: customAppBar('Usuarios',true),
            body: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                header: WaterDropHeader(
                  complete: Icon(
                    Icons.check,
                    color: Colors.blue[400],
                  ),
                  waterDropColor: Colors.blueAccent,
                ),
                onRefresh: () {
                  _.cargarUsuarios();
                  _refreshController.refreshCompleted();
                },
                child: _listViewUsuarios(_)
                // Obx(() {
                //   if (_socketProvider.usuarioConectado.value) {
                //     //_.cargarUsuarios();
                //     return _listViewUsuarios(_);
                //   } else {
                //     //_.cargarUsuarios();
                //     return _listViewUsuarios(_);
                //   }
                // }
                // )
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () => Get.toNamed(Routes.REGISTER),
                  tooltip: 'Agregar Usuario',
                  child: const Icon(Icons.add),
                ),
            );
      },
    );
  }

  ListView _listViewUsuarios(UsuarioController usuarioController) {
    //usuarioController.cargarUsuarios();
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) =>
            _usuariosTile(usuarioController.usuarios.value[i], usuarioController),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: usuarioController.usuarios.value.length);
  }

  ListTile _usuariosTile(Usuarios usuario, UsuarioController usuarioController) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.idUsuario),
      leading: const CircleAvatar(
        child: Icon(Icons.account_circle, size: 40, color: Colors.grey,)
      ),
      onTap: () async {
        usuarioController.usuarioProfile.value = usuario;
        Get.toNamed(Routes.PROFILE);
      },
    );
  }
}
