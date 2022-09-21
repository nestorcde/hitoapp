import 'package:get/get.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_controller.dart';
import 'package:hito_app/app/modules/settings/settings_controller.dart';
import 'package:hito_app/app/modules/settings/settings_response_model.dart';
import 'package:hito_app/app/routes/routes_app.dart';

class HomeOperController extends GetxController {
  //TODO: Implement HomeOperController
  late SettingsController _settingsController;
  late MovimientosController movimientosController;
  late SettingsResponse _settingsResponse;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    _settingsController = Get.find<SettingsController>();
    movimientosController = Get.find<MovimientosController>();
  }

  @override
  void onReady() async {
    super.onReady();
    _settingsResponse = await _settingsController.getSettings();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goToMovLocal(){
    movimientosController.tipoMovimiento.value = 1;
    movimientosController.importe.value = _settingsResponse.parametro.precioLocal;
    movimientosController.importeCtrl.value.text = movimientosController.f.format(_settingsResponse.parametro.precioLocal);
    movimientosController.paisOrigen.value = movimientosController.paisLocal.value;
    movimientosController.paisOrigenCtrl.value.text = movimientosController.paisLocal.value.nombre;
    movimientosController.cantidad.value = 1;
    movimientosController.cantidadCtrl.value.text = "1";
    Get.toNamed(Routes.MOVIMIENTOS);
  }
  void goToMovExtranjero(){
    movimientosController.paisOrigen.value = movimientosController.paisDefault;
    movimientosController.paisOrigenCtrl.value.text = "";
    movimientosController.tipoMovimiento.value = 2;
    movimientosController.importe.value = _settingsResponse.parametro.precioLocal + _settingsResponse.parametro.plusMercosur;
    movimientosController.importeCtrl.value.text = movimientosController.f.format(_settingsResponse.parametro.precioLocal + _settingsResponse.parametro.plusMercosur);
    movimientosController.cantidad.value = 1;
    movimientosController.cantidadCtrl.value.text = "1";
    Get.toNamed(Routes.MOVIMIENTOS);
  }
}
