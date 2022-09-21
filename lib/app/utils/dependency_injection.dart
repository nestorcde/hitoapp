//import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// ignore: unused_import
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:hito_app/app/modules/home/controllers/home.controller.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_controller.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_provider.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_repository.dart';
import 'package:hito_app/app/modules/paises/paises_controller.dart';
import 'package:hito_app/app/modules/paises/paises_provider.dart';
import 'package:hito_app/app/modules/paises/paises_repository.dart';
import 'package:hito_app/app/modules/settings/settings_controller.dart';
import 'package:hito_app/app/modules/settings/settings_provider.dart';
import 'package:hito_app/app/modules/settings/settings_repository.dart';
import 'package:http/http.dart';

import 'package:hito_app/app/data/provider/local/local_auth.dart';
import 'package:hito_app/app/data/provider/remote/auth_provider.dart';
import 'package:hito_app/app/data/repository/local/local_auth_repository.dart';
import 'package:hito_app/app/data/repository/remote/auth_repository.dart';
import 'package:hito_app/app/modules/landing/landing_controller.dart';
import 'package:hito_app/app/modules/loading/loading_controller.dart';
import 'package:hito_app/app/modules/login/login_controller.dart';
import 'package:hito_app/app/modules/profile/profile_controller.dart';
import 'package:hito_app/app/modules/profile/profile_provider.dart';
import 'package:hito_app/app/modules/profile/profile_repository.dart';
import 'package:hito_app/app/modules/usuario/usuarios_provider.dart';
import 'package:hito_app/app/modules/usuario/usuarios_repository.dart';
import 'package:hito_app/app/modules/usuario/usuarios_controller.dart';

class DependencyInjection {
  static Future<void> init() async{
    //Varios
    Get.put<FlutterSecureStorage>(const FlutterSecureStorage());
    Get.put<Client>(Client());

    //Providers
    Get.put<LocalAuth>(LocalAuth());
    Get.put<AuthProvider>(AuthProvider());
    Get.put<UsuarioProvider>(UsuarioProvider());
    Get.put<ProfileProvider>(ProfileProvider());
    Get.put<PaisesProvider>(PaisesProvider());
    Get.put<SettingsProvider>(SettingsProvider());
    Get.put<MovimientosProvider>(MovimientosProvider());
    
    //Repositories
    Get.put<LocalAuthRepository>(LocalAuthRepository());
    Get.put<AuthRepository>(AuthRepository());
    Get.put<UsuarioRepository>(UsuarioRepository());
    Get.put<ProfileRepository>(ProfileRepository());
    Get.put<PaisesRepository>(PaisesRepository());
    Get.put<SettingsRepository>(SettingsRepository());
    Get.put<MovimientosRepository>(MovimientosRepository());

    //Controllers
    //Get.put<LandingController>(LandingController());
    Get.put<LoadingController>(LoadingController());
    Get.put<LoginController>(LoginController());
    Get.put<UsuarioController>(UsuarioController());
    Get.put<ProfileController>(ProfileController());
    Get.put<HomeController>(HomeController());
    Get.put<PaisesController>(PaisesController());
    Get.put<SettingsController>(SettingsController());
    Get.put<MovimientosController>(MovimientosController());

  }
}