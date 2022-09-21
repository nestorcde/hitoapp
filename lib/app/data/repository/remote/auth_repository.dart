
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/data/provider/remote/auth_provider.dart';
import 'package:http/src/response.dart';

class AuthRepository {

  final AuthProvider _api = Get.find<AuthProvider>();

  Usuarios get usuario => _api.usuario;

 set usuarioAuth(Usuarios usuario) => _api.usuarioAuth = usuario;

set autenticando(bool valor) {
  _api.autenticando = valor;
}
  bool get autenticando => _api.autenticando;

  Future<bool> login(String idUsuario, String password) => _api.login(idUsuario, password);

  Future logout() => _api.logout();

  Future signIn(String idUsuario, String nombre, String password, String tipo) => _api.signIn(idUsuario, nombre, password, tipo);

  Future<bool> isLoggedIn()=> _api.isLoggedIn();

  Future<String?> getToken()=> _api.getToken();

  Future<void> deleteToken()=> _api.deleteToken();

  Future<http.Response> changePassword(String value, String value2) => _api.changePassword(value, value2);

}