import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/pais_request.dart';
import 'package:http/http.dart' as http;
import 'package:hito_app/app/data/models/paises_model.dart';
import 'package:hito_app/app/data/models/paises_response.dart';
import 'package:hito_app/app/modules/paises/paises_repository.dart';
import 'package:hito_app/app/ui/widgets/mostrar_alerta.dart';
import 'package:hito_app/app/utils/constants.dart';



class PaisesController extends GetxController {

  final PaisesRepository _paisesRepository = Get.find<PaisesRepository>();

  RxInt idPaisSelected = 0.obs;
  RxString nombreSelected = "".obs;
  RxBool mercosurSelected = false.obs, editNombre = false.obs, editMercosur = false.obs, verBtnGuardar = false.obs, guardando = false.obs;
  Rx<Paises> paisSelected = Paises(idPais: 0, mercosur: false, nombre: '', uid: '').obs;
  Rx<TextEditingController> idPaisCtrl = TextEditingController().obs;
  Rx<TextEditingController> nombreCtrl = TextEditingController().obs;

  Paises paisesDefault = Paises(idPais: 0, mercosur: false, nombre: '', uid: '');
  RxList<Paises> paises = [Paises(idPais: 0, mercosur: false, nombre: '', uid: '')].obs;

  

  Future<List<Paises>> getAllPaises()  =>  _paisesRepository.getPaises();

  Rx<ServerStatus>  estado = ServerStatus.Connecting.obs;

  cargarPaises() async{
      paises.value = await _paisesRepository.getPaises();
      update();
  }
  
  activarEdicion(){
    editNombre.value = true;
    editMercosur.value = true;
    verBtnGuardar.value = true;
  }

  desactivarEdicion(){
    editNombre.value = false;
    editMercosur.value = false;
    verBtnGuardar.value = false;
  }

  nombreOnChange(String text){
    nombreSelected.value = text;
  }
  
  mercosurOnChange(bool mercosur){
    mercosurSelected.value = mercosur;
  }

  vaciarControlesNewPais(){
    idPaisCtrl.value.text = '';
    nombreCtrl.value.text = '';
    mercosurSelected.value = false;
  }
  
  Future<PaisRequest> guardarDatos() async {
    if(nombreCtrl.value.text == ""){
        await mostrarAlerta(Get.context!, 'Error de Campos obligatorios', 'Todos los campos son obligatorios');
          idPaisCtrl.value.text = paisSelected.value.idPais.toString();
          nombreCtrl.value.text = paisSelected.value.nombre;
          mercosurSelected.value = paisSelected.value.mercosur;
        desactivarEdicion();
        return PaisRequest(ok: false, msg: 'msg', paises: paisSelected.value );
    }else{
      if(idPaisSelected.value>0) paisSelected.value.idPais = int.parse(idPaisCtrl.value.text);
        paisSelected.value.nombre = nombreCtrl.value.text;
        paisSelected.value.mercosur = mercosurSelected.value;
        final http.Response response = idPaisSelected.value>0? 
          await _paisesRepository.updatePais(
            paisSelected.value.idPais,
            paisSelected.value.nombre,
            paisSelected.value.mercosur):
          await _paisesRepository.createPais(
            paisSelected.value.nombre,
            paisSelected.value.mercosur);
      if(response.statusCode==200){
        PaisRequest paisResponse = paisRequestFromJson(response.body);
        if(paisResponse.ok){
          if(idPaisSelected.value>0){
            idPaisCtrl.value.text = paisSelected.value.idPais.toString();
            nombreCtrl.value.text = paisSelected.value.nombre;
            mercosurSelected.value = paisSelected.value.mercosur;
          }
          desactivarEdicion();
          cargarPaises();
        }
        return paisResponse;
      }else{
        await mostrarAlerta(Get.context!, 'Error de servidor', 'Comuniquese con el Administrador Error: ${response.body}');
          idPaisCtrl.value.text = paisSelected.value.idPais.toString();
          nombreCtrl.value.text = paisSelected.value.nombre;
          mercosurSelected.value = paisSelected.value.mercosur;
        desactivarEdicion();
        return PaisRequest(ok: false, msg: 'msg', paises: paisSelected.value);
      }
    }
  }


}