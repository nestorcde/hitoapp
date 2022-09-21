import 'package:get/get.dart';
import 'package:hito_app/app/modules/home/home.screen.dart';
import 'package:hito_app/app/modules/home/home_binding.dart';
import 'package:hito_app/app/modules/home_oper/home_oper.screen.dart';
import 'package:hito_app/app/modules/landing/landing_page.dart';
import 'package:hito_app/app/modules/loading/loading_binding.dart';
import 'package:hito_app/app/modules/login/change_password_page.dart';
import 'package:hito_app/app/modules/login/login_binding.dart';
import 'package:hito_app/app/modules/login/login_page.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_binding.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_page.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_resumen_detalles.dart';
import 'package:hito_app/app/modules/paises/pais_new_page.dart';
import 'package:hito_app/app/modules/paises/pais_page.dart';
import 'package:hito_app/app/modules/paises/paises_binding.dart';
import 'package:hito_app/app/modules/paises/paises_page.dart';
import 'package:hito_app/app/modules/profile/profile_binding.dart';
import 'package:hito_app/app/modules/profile/profile_page.dart';
import 'package:hito_app/app/modules/register/register_binding.dart';
import 'package:hito_app/app/modules/register/register_page.dart';
import 'package:hito_app/app/modules/settings/settings_binding.dart';
import 'package:hito_app/app/modules/settings/settings_page.dart';
import 'package:hito_app/app/modules/usuario/usuarios_binding.dart';
import 'package:hito_app/app/modules/usuario/usuarios_page.dart';
import 'package:hito_app/app/routes/routes_app.dart';
import 'package:hito_app/app/modules/loading/loading_page.dart';

import '../modules/home_oper/home_oper_binding.dart';
import '../modules/movimientos/movimientos_resumen_consulta_page.dart';

abstract class AppPages {

  static final pages = [
    GetPage(
      name: Routes.LOGIN, 
      page:()=> const LoginPage(), 
      binding: LoginBinding()
    ),
    GetPage(
      name: Routes.REGISTER, 
      page:()=> const RegisterPage(), 
      binding: RegisterBinding()
    ),
    GetPage(
      name: Routes.LOADING, 
      page:()=> const LoadingPage(), 
      binding: LoadingBinding()
    ),
    GetPage(
      name: Routes.USUARIO, 
      page:()=> const UsuariosPage(), 
      binding: UsuarioBinding()
    ),
    GetPage(
      name: Routes.PROFILE, 
      page:()=>  ProfilePage(), 
      binding: ProfileBinding()
    ),
    // GetPage(
    //   name: Routes.LANDING, 
    //   page:()=> LandingPage(), 
    // ),
    GetPage(
      name: Routes.HOME, 
      page:()=>  HomeScreen(), 
      binding: HomeBinding()
    ),
    GetPage(
      name: Routes.HOMEOPER, 
      page:()=>  HomeOperScreen(), 
      binding: HomeOperBinding()
    ),
    GetPage(
      name: Routes.SETTINGS, 
      page:()=> SettingsPage(), 
      binding: SettingsBinding()
    ),
    GetPage(
      name: Routes.CHANGEPASSWORD, 
      page:()=> const ChangePasswordPage(), 
      binding: LoadingBinding()
    ),
    GetPage(
      name: Routes.PAISES, 
      page:()=> const PaisesPage(), 
      binding: PaisesBinding()
    ),
    GetPage(
      name: Routes.PAIS, 
      page:()=>  PaisPage(), 
      binding: PaisesBinding()
    ),
    GetPage(
      name: Routes.PAIS_NEW, 
      page:()=>  const PaisNewPage(), 
      binding: PaisesBinding()
    ),
    GetPage(
      name: Routes.MOVIMIENTOS, 
      page:()=>  MovimientosPage(), 
      binding: MovimientosBinding()
    ),
    GetPage(
      name: Routes.MOVIMIENTOSRESU, 
      page:()=>  MovimientosResumenConsultaPage(), 
      binding: MovimientosBinding()
    ),
    GetPage(
      name: Routes.MOVIMIENTOSDETA, 
      page:()=>  MovimientosResumenDetalle(), 
      binding: MovimientosBinding()
    ),
    
  ];
}