
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/modules/profile/profile_provider.dart';

class ProfileRepository {
  final ProfileProvider api = Get.find<ProfileProvider>();

  //Usuario get usuario => api.usuario;

  Future<http.Response> updateProfile(String idUsuario, String nombre,
          Usuarios usuario, String tipoUsuario) =>
      api.updateProfile(idUsuario, nombre, usuario, tipoUsuario);

  resetPassword(Rx<Usuarios> usuarioProfile) async{
    await api.resetPassword(usuarioProfile);
  }
}
