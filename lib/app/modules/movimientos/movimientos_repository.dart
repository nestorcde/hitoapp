import 'package:get/get.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_request.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/modules/movimientos/movimientos_provider.dart';

class MovimientosRepository {
  final MovimientosProvider api = Get.find<MovimientosProvider>();
  Future<http.Response> crearMovimiento(
          MovimientosRequest movimientosRequest) async =>
      await api.crearMovimiento(movimientosRequest);
  Future<http.Response> obtenerMovimientos(
          String fchDesde, String fchHasta, String idUsuario) async =>
      await api.obtenerMovimientos(fchDesde,fchHasta,idUsuario);
  Future<http.Response> obtenerMovimientosDet(
          String fchDesde, String fchHasta, String idUsuario) async =>
      await api.obtenerMovimientosDet(fchDesde,fchHasta,idUsuario);
}
