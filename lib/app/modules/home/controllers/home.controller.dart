import 'package:get/get.dart';
import 'package:hito_app/app/routes/routes_app.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void goToSettings() => Get.toNamed(Routes.SETTINGS);
  void goToUsers() => Get.toNamed(Routes.USUARIO);
  void goToReports() => Get.toNamed(Routes.MOVIMIENTOSRESU);
  void goToPaises() => Get.toNamed(Routes.PAISES);
}
