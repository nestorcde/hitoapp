import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/paises_model.dart';
import 'package:hito_app/app/data/models/paises_response.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/data/models/usuarios_response.dart';
import 'package:hito_app/app/utils/constants.dart';


//nossa classe responsável por encapsular os métodos http
class PaisesProvider {
  
  
  
  Future<List<Paises>> getPaises() async {
    try {
      final resp = await http.get(Environment().apiUrl('/paises'),
        headers: {
          'Content-Type': 'application/json'
        }
      );

      final paisesResponse = paisesRequestFromJson(resp.body);

      return paisesResponse.paises;
    } catch (e) {
      return [];
    }
  }

  Future<http.Response> updatePais(
      int idPais, String nombre, bool mercosur) async {
    final data = {
      "idPais": idPais,
      "nombre": nombre,
      "mercosur": mercosur
    };
    
    return  await http.post(Environment().apiUrl('/paises'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});
  }

  Future<http.Response> createPais(String nombre, bool mercosur) async {
    final data = {
      "nombre": nombre,
      "mercosur": mercosur
    };
    
    return  await http.post(Environment().apiUrl('/paises/new'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'});
  }

}