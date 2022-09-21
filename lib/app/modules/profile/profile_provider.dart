import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/ui/widgets/mostrar_alerta.dart';
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/data/provider/remote/auth_provider.dart';
import 'package:hito_app/app/utils/constants.dart';

class ProfileProvider extends GetConnect {
  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();
  final AuthProvider authProvider = Get.find<AuthProvider>();

  Future<http.Response> updateProfile(
      String idUsuario, String nombre, Usuarios usuario, String tipoUsuario) async {
    final data = {
      "uid": usuario.uid,
      "idUsuario": nombre,
      "nombre": nombre,
      "tipo": tipoUsuario
    };
    //print(data);
    final token = await _storage.read(key: "token");
    //print('email: ${email} - pass: ${password}');
    return  await http.post(Environment().apiUrl('/usuarios'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''});

    
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  resetPassword(Rx<Usuarios> usuarioProfile) async {
    final data = {
      "idUsuario": usuarioProfile.value.idUsuario,
      "password": usuarioProfile.value.idUsuario
    };
    //print(data);
    final token = await _storage.read(key: "token");
    //print('email: ${email} - pass: ${password}');
    http.Response resp = await http.post(Environment().apiUrl('/login/repsw'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''});
    final response = jsonDecode(resp.body);
    final titulo = response["ok"]?"Proceso Exitoso":"Error";
    mostrarAlerta(Get.context!, titulo, response["msg"]);
  
  }
}
