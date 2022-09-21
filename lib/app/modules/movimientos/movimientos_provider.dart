
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'package:hito_app/app/modules/movimientos/movimientos_request.dart';
import 'package:hito_app/app/utils/constants.dart';
import 'package:http/http.dart' as http;


class MovimientosProvider {

  final FlutterSecureStorage _storage = Get.find<FlutterSecureStorage>();

  Future<http.Response> crearMovimiento(MovimientosRequest movimientosRequest) async{
      final token = await _storage.read(key: 'token');
      final data = {
            "idUsuario": movimientosRequest.idUsuario,
            "idPais": movimientosRequest.idPais,
            "tipoIngreso": movimientosRequest.tipoIngreso,
            "importe": movimientosRequest.importe,
            "cantidad": movimientosRequest.cantidad
          };
      return await http.post(Environment().apiUrl('/movimientos/nuevo'),
          body: jsonEncode(data),
          headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        });
  }

  Future<http.Response> obtenerMovimientos(String fchDesde, String fchHasta, String idUsuario) async{
      final token = await _storage.read(key: 'token');
      final data = {
            "fchDesde": fchDesde,
            "fchHasta": fchHasta,
            "idUsuario": idUsuario
          };
      return await http.post(Environment().apiUrl('/movimientos'),
          body: jsonEncode(data),
          headers: {
          'Content-Type': 'application/json',
          'x-token': token.toString()
        });
  }

}