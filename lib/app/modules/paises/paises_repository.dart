
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/paises_model.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/modules/paises/paises_provider.dart';

class PaisesRepository {

  final PaisesProvider api = Get.find<PaisesProvider>();

  Future<http.Response> updatePais(int idPais, String nombre, bool mercosur) =>
      api.updatePais(idPais, nombre, mercosur);

  Future<http.Response> createPais(String nombre, bool mercosur) =>
  api.createPais(nombre, mercosur);

  Future<List<Paises>> getPaises() async => await api.getPaises();

}