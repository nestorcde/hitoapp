
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/modules/usuario/usuarios_provider.dart';
import 'package:get/get.dart';

class UsuarioRepository {

  final UsuarioProvider api = Get.find<UsuarioProvider>();

  Future<List<Usuarios>> getUsuarios()  =>  api.getUsuarios();

  Future<void> setTuto(String uid) => api.setTuto(uid);

}