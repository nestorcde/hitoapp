// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/paises_model.dart';
import 'package:hito_app/app/modules/paises/paises_controller.dart';
import 'package:hito_app/app/modules/settings/settings_model.dart';
import 'package:hito_app/app/modules/settings/settings_repository.dart';
import 'package:hito_app/app/modules/settings/settings_response_model.dart';
import 'package:hito_app/app/ui/widgets/mostrar_alerta.dart';
import 'package:http/http.dart' as http;

class SettingsController extends GetxController {

final SettingsRepository repository = Get.find<SettingsRepository>();
late PaisesController paisesCtrl;
 List<Paises> listPaises = [];
@override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    paisesCtrl = Get.find<PaisesController>();
    listPaises = await paisesCtrl.getAllPaises();
  }
  @override
  void onReady()async {
    // TODO: implement onReady
    super.onReady();
  }
  Settings settingsDefault = Settings( uid: '', precioLocal: 0, descMayores: 0, descMenores: 0, plusMercosur: 0, plusNoMercosur: 0, plusFinde: 0, paises: Paises(uid: "", idPais: 0, nombre: "",mercosur: false));
  Rx<Settings> settings = Settings(uid: '', precioLocal: 0, descMayores: 0, descMenores: 0, plusMercosur: 0, plusNoMercosur: 0, plusFinde: 0, paises: Paises(uid: "", idPais: 0, nombre: "",mercosur: false)).obs;

  RxBool editPrecioLocal = false.obs, editPlusMerc = false.obs, editPlusNoMerc = false.obs, editPlusFinde = false.obs, editDescMen = false.obs, editDescMay = false.obs, editPaisLocal = false.obs, responseOk = false.obs, verBtnGuardar = false.obs;
  RxString prLocal = ''.obs, plMerc = ''.obs, plNoMerc = ''.obs, plFinde = ''.obs, dsMen = ''.obs, dsMay = ''.obs;
  Rx<TextEditingController> prLocalCtrl = TextEditingController().obs;
  Rx<TextEditingController> plusMercCtrl = TextEditingController().obs;
  Rx<TextEditingController> plusNoMercCtrl = TextEditingController().obs;
  Rx<TextEditingController> plusFindeCtrl = TextEditingController().obs;
  Rx<TextEditingController> descMenoresCtrl = TextEditingController().obs;
  Rx<TextEditingController> descMayoresCtrl = TextEditingController().obs;
  Rx<TextEditingController> paisLocalCtrl = TextEditingController().obs;
  Rx<Paises> paisLocal = Paises(idPais: 0, nombre: "nombre", mercosur: false, uid: "").obs;
  Rx<Paises> paisLocalSetting = Paises(idPais: 0, nombre: "nombre", mercosur: false, uid: "").obs;


  activarEdicion(){
    editPrecioLocal.value = true;
    editPlusMerc.value = true;
    editPlusNoMerc.value = true;
    editPlusFinde.value = true;
    editDescMen.value = true;
    editDescMay.value = true;
    editPaisLocal.value = true;
    verBtnGuardar.value = true;
  }

  desactivarEdicion(){
    editPrecioLocal.value = false;
    editPlusMerc.value = false;
    editPlusNoMerc.value = false;
    editPlusFinde.value = false;
    editDescMen.value = false;
    editDescMay.value = false;
    editPaisLocal.value = false;
    verBtnGuardar.value = false;
  }

  prLocalOnChanged(String text){
    //print(text);
    prLocal.value = text;
  }

  plMercOnChanged(String text){
    //print(text);
    plMerc.value = text;
  }

  plNoMercOnChanged(String text){
    //print(text);
    plNoMerc.value = text;
  }

  plFindeOnChanged(String text){
    //print(text);
    plFinde.value = text;
  }

  dsMenOnChanged(String text){
    //print(text);
    dsMen.value = text;
  }

  dsMayOnChanged(String text){
    //print(text);
    dsMay.value = text;
  }

  paisLocalOnChanged(Paises pais){
    //print(text);
    paisLocal.value = pais;
    paisLocalCtrl.value.text = pais.nombre;
  }

  Future<SettingsResponse> getSettings() async{

    final http.Response response = await repository.getSettings();
    if(response.statusCode==200){
      SettingsResponse settingsResponseModel = settingsResponseFromJson(response.body);
      if(settingsResponseModel.ok){
        responseOk.value = true;
        settings.value = settingsResponseModel.parametro;
        prLocalCtrl.value.text = settingsResponseModel.parametro.precioLocal.toString();
        plusMercCtrl.value.text = settingsResponseModel.parametro.plusMercosur.toString();
        plusNoMercCtrl.value.text = settingsResponseModel.parametro.plusNoMercosur.toString();
        plusFindeCtrl.value.text = settingsResponseModel.parametro.plusFinde.toString();
        descMenoresCtrl.value.text = settingsResponseModel.parametro.descMenores.toString();
        descMayoresCtrl.value.text = settingsResponseModel.parametro.descMayores.toString();
        paisLocal.value = settingsResponseModel.parametro.paises;
        paisLocalCtrl.value.text = paisLocal.value.nombre;
        desactivarEdicion();
      }else{
        responseOk.value = false;
        settings.value = settingsDefault;
        prLocalCtrl.value.text = "";
        plusMercCtrl.value.text = "";
        plusNoMercCtrl.value.text = "";
        plusFindeCtrl.value.text = "";
        descMenoresCtrl.value.text = "";
        descMayoresCtrl.value.text = "";
        paisLocal.value = settingsDefault.paises;
        desactivarEdicion();
      }
      return settingsResponseModel;
    }else{
      await mostrarAlerta(Get.context!, 'Error de servidor', 'Comuniquese con el Administrador');
      desactivarEdicion();
      return SettingsResponse(ok: false, msg: 'msg', parametro: settings.value);
    }
    
  }

  Future<SettingsResponse> workWithSettings() async{
    //print("Local: ${prLocal.value} - Extranjero: ${prExtr.value}");
    if(prLocalCtrl.value.text == "0" || prLocalCtrl.value.text == "" || plusMercCtrl.value.text == "0" || plusMercCtrl.value.text == "" ){
        await mostrarAlerta(Get.context!, 'Error de Campos obligatorios', 'Los precios deben ser mayores a 0 (cero)');
          prLocalCtrl.value.text = settings.value.precioLocal.toString();
          plusMercCtrl.value.text = settings.value.plusMercosur.toString();
          plusNoMercCtrl.value.text = settings.value.plusNoMercosur.toString();
          plusFindeCtrl.value.text = settings.value.plusFinde.toString();
          descMenoresCtrl.value.text = settings.value.descMenores.toString();
          descMayoresCtrl.value.text = settings.value.descMayores.toString();
          paisLocal.value = settings.value.paises;
        desactivarEdicion();
        return SettingsResponse(ok: false, msg: 'msg', parametro: settings.value);
    }else{
      settings.value.precioLocal = int.parse(prLocalCtrl.value.text);
      settings.value.plusMercosur = int.parse(plusMercCtrl.value.text);
      settings.value.plusNoMercosur = int.parse(plusNoMercCtrl.value.text);
      settings.value.plusFinde = int.parse(plusFindeCtrl.value.text);
      settings.value.descMenores = int.parse(descMenoresCtrl.value.text);
      settings.value.descMayores = int.parse(descMayoresCtrl.value.text);
      settings.value.paises = paisLocal.value;
      final http.Response response = settings.value.uid==''? await repository.createSettings(settings.value): await repository.updateSettings(settings.value);
      if(response.statusCode==200){
        SettingsResponse settingsResponseModel = settingsResponseFromJson(response.body);
        if(settingsResponseModel.ok){
          responseOk.value = true;
          settings.value = settingsResponseModel.parametro;
          prLocalCtrl.value.text = settingsResponseModel.parametro.precioLocal.toString();
          plusMercCtrl.value.text = settingsResponseModel.parametro.plusMercosur.toString();
          plusNoMercCtrl.value.text = settingsResponseModel.parametro.plusNoMercosur.toString();
          plusFindeCtrl.value.text = settingsResponseModel.parametro.plusFinde.toString();
          descMenoresCtrl.value.text = settingsResponseModel.parametro.descMenores.toString();
          descMayoresCtrl.value.text = settingsResponseModel.parametro.descMayores.toString();
          paisLocal.value = settingsResponseModel.parametro.paises;
          desactivarEdicion();
        }else{
          responseOk.value = false;
          settings.value = settingsDefault;
          prLocalCtrl.value.text = "";
          plusMercCtrl.value.text = "";
          plusNoMercCtrl.value.text = "";
          plusFindeCtrl.value.text = "";
          descMenoresCtrl.value.text = "";
          descMayoresCtrl.value.text = "";
          paisLocal.value = settings.value.paises;
          desactivarEdicion();
        }
        return settingsResponseModel;
      }else{
        await mostrarAlerta(Get.context!, 'Error de servidor', 'Comuniquese con el Administrador');
          prLocalCtrl.value.text = settings.value.precioLocal.toString();
          plusMercCtrl.value.text = settings.value.plusMercosur.toString();
          plusNoMercCtrl.value.text = settings.value.plusNoMercosur.toString();
          plusFindeCtrl.value.text = settings.value.plusFinde.toString();
          descMenoresCtrl.value.text = settings.value.descMenores.toString();
          descMayoresCtrl.value.text = settings.value.descMayores.toString();
          paisLocal.value = settings.value.paises;
        desactivarEdicion();
        return SettingsResponse(ok: false, msg: 'msg', parametro: settings.value);
      }
    }
  }
}