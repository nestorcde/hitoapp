import 'dart:convert';

import 'package:get/get.dart';
import 'package:hito_app/app/modules/settings/settings_model.dart';
import 'package:hito_app/app/utils/constants.dart';
import 'package:http/http.dart' as http;

const baseUrl = 'http://gerador-nomes.herokuapp.com/nomes/10';

class SettingsProvider {


  // Get request
  //Future<Response> getSettings() => get(Environment().stringUrl('/parametros'));
  Future<http.Response> getSettings() async => await http.get(Environment().apiUrl('/parametros'));

  Future<http.Response> createSettings(Settings settings) async {
      
      final data = {
            "precioLocal": settings.precioLocal,
            "plusMercosur": settings.plusMercosur,
            "plusNoMercosur": settings.plusNoMercosur,
            "plusFinde": settings.plusFinde,
            "descMenores": settings.descMenores,
            "descMayores": settings.descMayores,
            "paises": settings.paises.uid
          };
          
      return await http.post(Environment().apiUrl('/parametros/new'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
  }

  Future<http.Response> updateSettings(Settings settings) async{
      final data = {
            "uid": settings.uid,
            "precioLocal": settings.precioLocal,
            "plusMercosur": settings.plusMercosur,
            "plusNoMercosur": settings.plusNoMercosur,
            "plusFinde": settings.plusFinde,
            "descMenores": settings.descMenores,
            "descMayores": settings.descMayores,
            "paises": settings.paises.uid
          };
      return await http.post(Environment().apiUrl('/parametros'),
          body: jsonEncode(data),
          headers: {'Content-Type': 'application/json'});
  }
}