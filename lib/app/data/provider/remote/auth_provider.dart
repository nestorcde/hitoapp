// ignore_for_file: unnecessary_getters_setters

import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:hito_app/app/data/models/login_response.dart';
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/utils/constants.dart';


class AuthProvider extends GetConnect {

  //final HttpClient _httpClient = Get.find<HttpClient>();

  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  late Usuarios usuario;
  
  void set usuarioAuth(Usuarios usr){
    usuario = usr;
  }

  final RxBool _autenticando = false.obs;


  bool get autenticando => _autenticando.value;

  set autenticando( bool valor ){
    _autenticando.value = valor;
  }

  

  //Getters del token 
   Future<String?> getToken() async {
    final token = await _storage.read(key: 'token');
    return token;
  }

   Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }


  Future<bool> login( String idUsuario, String password) async {

    autenticando = true;

    final data = {
      "idUsuario": idUsuario,
      "password": password
    };
    //print(jsonEncode(data));
    //print('idUsuario: ${idUsuario} - pass: ${password}');
    final http.Response  resp = await http.post(
      Environment().apiUrl('/login'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      }
    );
    autenticando = false;

    if(resp.statusCode==200){
      //print(resp.body);
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    }else{
      return false;
    }


  }

   Future signIn(String idUsuario, String nombre, String  password, String tipo) async {

    autenticando = true;

    final data = {
      "nombre": nombre,
      "tipo": tipo,
      "idUsuario": idUsuario,
      "password": password
    };
    //print('idUsuario: ${idUsuario} - pass: ${password}');
    final http.Response resp = await http.post(Environment().apiUrl('/login/new'), 
      body: jsonEncode(data),
      headers:{
        'Content-Type': 'application/json',
      }
    );
    autenticando = false;

    if(resp.statusCode==200){
      // final loginResponse = loginResponseFromJson(resp.body);
      // usuario = loginResponse.usuario;
      
      //   await _guardarToken(loginResponse.token);

      return true;
    }else{
      final respBody = json.decode(resp.body);
      return respBody['msg'] ?? 'Error en el registro';
    }


  }

  Future _guardarToken(String token) async{
      return await  _storage.write(key: 'token', value: token);
  }

  Future logout() async{
    return await _storage.delete(key: 'token');
  }

  Future<bool> isLoggedIn() async {
    autenticando = true;
    final token = await _storage.read(key: "token");
    final http.Response resp = await http.get(
      Environment().apiUrl('/login/renew'), 
      headers: {
        'Content-Type': 'application/json',
          'x-token': token ?? ''
        }
      ).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        // Time has run out, do what you wanted to do.
        return http.Response('Error', 408); // Request Timeout response status code
      });

    //print('Respuesta isLoggedIn: ${resp.statusCode}');

    autenticando = false;

    if(resp.statusCode==200){
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);
      return true;
    }else{
      logout();
      return false;
    }
  }

  Future<http.Response> changePassword(String value, String value2) async{
    final data = {
      "idUsuario": value,
      "password": value2
    };
    final token = await _storage.read(key: "token");
    return await http.post(Environment().apiUrl('/login/chgpsw'), 
      body: jsonEncode(data),
      headers:{
        'Content-Type': 'application/json',
          'x-token': token ?? ''
      }
    );

  }

}