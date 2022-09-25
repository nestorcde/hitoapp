import 'dart:io';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/services.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_detalle_request.dart';
//import 'package:open_document/open_document.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
//import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_resumen_response.dart';
import 'package:hito_app/app/modules/usuario/usuarios_controller.dart';
import 'package:hito_app/app/routes/routes_app.dart';
import 'package:http/http.dart' as http;
//import 'dart:async';

import 'package:hito_app/app/data/models/paises_model.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_repository.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_request.dart';
import 'package:hito_app/app/modules/paises/paises_controller.dart';
import 'package:hito_app/app/modules/settings/settings_controller.dart';
import 'package:hito_app/app/modules/settings/settings_model.dart';
import 'package:hito_app/app/modules/settings/settings_response_model.dart';
import 'package:intl/intl.dart';

import '../../data/repository/remote/auth_repository.dart';
import '../../ui/widgets/mostrar_alerta.dart';
import 'package:hito_app/app/utils/printerenum.dart';

enum TipoFecha {
    FchDesde,
    FchHasta
  }

class MovimientosController extends GetxController {
  final MovimientosRepository repository = Get.find<MovimientosRepository>();

  late AuthRepository _authRepository;
  late PaisesController _paisCtrl;
  late SettingsController _settingsCtrl;
  late SettingsResponse _settingsResponse;
  late UsuarioController _usuarioController;

  late Settings settings;
  late List<Paises> listaPaises;
  late List<Paises> listaPaisesEx = [];
  late List<Usuarios> listaUsuarios = [];
  final Paises paisDefault =
      Paises(idPais: 0, nombre: "", mercosur: false, uid: "");
  Rx<Paises> paisOrigen =
      Paises(idPais: 0, nombre: "", mercosur: false, uid: "").obs;
  Rx<Paises> paisLocal =
      Paises(idPais: 0, nombre: "", mercosur: false, uid: "").obs;
  RxInt importe = 0.obs, cantidad = 1.obs;
  RxInt tipoMovimiento = 0.obs;
  Rx<material.TextEditingController> paisOrigenCtrl =
      material.TextEditingController().obs;
  Rx<material.TextEditingController> importeCtrl =
      material.TextEditingController().obs;
  Rx<material.TextEditingController> cantidadCtrl =
      material.TextEditingController().obs;
  RxBool autenticando = false.obs;
  final MovimientosRequest movimientoDefault =
      MovimientosRequest(idUsuario: "", idPais: "", tipoIngreso: 0, importe: 0, cantidad: 1);
  Rx<MovimientosRequest> movimiento =
      MovimientosRequest(idUsuario: "", idPais: "", tipoIngreso: 0, importe: 0, cantidad: 1)
          .obs;
  final count = 0.obs;
  late BlueThermalPrinter bluetooth;
  NumberFormat f = NumberFormat.simpleCurrency(
      name: 'Gs', locale: 'es_PY', decimalDigits: 0);

  List<BluetoothDevice> devices = [];
  BluetoothDevice? device;
  RxBool connected = false.obs;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  
  

  Resumen resumenDefault = Resumen(
      cantMovLocal: 0,
      impMovLocal: 0,
      cantMovMerc: 0,
      impMovMerc: 0,
      cantMovNoMerc: 0,
      impMovNoMerc: 0);
  Rx<Resumen> resumen = Resumen(
          cantMovLocal: 0,
          impMovLocal: 0,
          cantMovMerc: 0,
          impMovMerc: 0,
          cantMovNoMerc: 0,
          impMovNoMerc: 0)
      .obs;
  RxString fchDesde = "".obs, fchHasta = "".obs, idUsuario = "".obs;
  Rx<material.TextEditingController> fchDesdeCtrl =
          material.TextEditingController().obs,
      fchHastaCtrl = material.TextEditingController().obs,
      nombreUsuarioCtrl = material.TextEditingController().obs;
  Detalle detalleDefault = Detalle(num: 0, fecha: '', cantidad: 0, importe: 0, pais: '', usuario: '');
  Rx<Detalle> detalle = Detalle(num: 0, fecha: '', cantidad: 0, importe: 0, pais: '', usuario: '').obs;
  RxList<Detalle> detalles = [Detalle(num: 0, fecha: '', cantidad: 0, importe: 0, pais: '', usuario: '')].obs;

  paisOrigeOnChange(Paises pais) {
    if (pais == paisLocal.value) {
      paisOrigenCtrl.value.text = '';
      paisOrigen.value = paisDefault;
      mostrarAlerta(Get.context!, 'Pais incorrecto',
          'Debe seleccionar otro pais o elegir visitante Local');
    } else {
      paisOrigenCtrl.value.text = pais.nombre;
      paisOrigen.value = pais;
      importe.value = cantidad.value * (pais.mercosur
          ? settings.precioLocal + settings.plusMercosur
          : settings.precioLocal + settings.plusNoMercosur);
      importeCtrl.value.text = f.format(importe.value);
      tipoMovimiento.value = pais.mercosur ? 2 : 3;
    }
  }

  incrementar(){
    cantidad.value ++;
    cantidadCtrl.value.text = cantidad.value.toString();
    importe.value = cantidad.value * (paisOrigen.value == paisLocal.value? 
        settings.precioLocal:
          paisOrigen.value.mercosur
          ? settings.precioLocal + settings.plusMercosur
          : settings.precioLocal + settings.plusNoMercosur);
    importeCtrl.value.text = f.format(importe.value);
  }

  decrementar(){
    cantidad.value --;
    cantidadCtrl.value.text = cantidad.value.toString();
    importe.value = cantidad.value * (paisOrigen.value == paisLocal.value? 
        settings.precioLocal:
          paisOrigen.value.mercosur
          ? (settings.precioLocal + settings.plusMercosur)
          : (settings.precioLocal + settings.plusNoMercosur));
    importeCtrl.value.text = f.format(importe.value);
  }

  @override
  void onInit() {
    super.onInit();
    _paisCtrl = Get.find<PaisesController>();
    _settingsCtrl = Get.find<SettingsController>();
    _authRepository = Get.find<AuthRepository>();
    _usuarioController = Get.find<UsuarioController>();
    bluetooth = BlueThermalPrinter.instance;
    initPlatformState();
  }

  @override
  void onReady() async {
    super.onReady();
    listaPaises = await _paisCtrl.getAllPaises();
    _settingsResponse = await _settingsCtrl.getSettings();
    settings = _settingsResponse.parametro;
    paisLocal.value = settings.paises;
    for (var element in listaPaises) {
      if (element.uid != paisLocal.value.uid) listaPaisesEx.add(element);
    }
    listaUsuarios = await _usuarioController.getAllUsuarios();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }

  Future<void> initPlatformState() async {
    try {
      await bluetooth.isConnected.then((value) => {
        connected.value = value!
      });
      //List<BluetoothDevice> devices = [];
      //try {
      if(!connected.value){  
        devices = await bluetooth.getBondedDevices();
        // } on PlatformException catch(e) {
        //   print(e);
        // }

        bluetooth.onStateChanged().listen((state)async {
          switch (state) {
            case BlueThermalPrinter.CONNECTED:
              connected.value = true;
              update();
              print("bluetooth device state: connected");
              break;
            case BlueThermalPrinter.DISCONNECTED:
              connected.value = false;
              update();
              print("bluetooth device state: disconnected");
              break;
            case BlueThermalPrinter.DISCONNECT_REQUESTED:
              connected.value = false;
              update();
              print("bluetooth device state: disconnect requested");
              break;
            case BlueThermalPrinter.STATE_TURNING_OFF:
              connected.value = false;
              update();
              print("bluetooth device state: bluetooth turning off");
              break;
            case BlueThermalPrinter.STATE_OFF:
              connected.value = false;
              update();
              print("bluetooth device state: bluetooth off");
              break;
            case BlueThermalPrinter.STATE_ON:
              connected.value = false;
              devices = await bluetooth.getBondedDevices();
              update();
              print("bluetooth device state: bluetooth on");
              break;
            case BlueThermalPrinter.STATE_TURNING_ON:
              connected.value = false;
              update();
              print("bluetooth device state: bluetooth turning on");
              break;
            case BlueThermalPrinter.ERROR:
              connected.value = false;
              update();
              print("bluetooth device state: error");
              break;
            default:
              print(state);
              break;
          }
        });
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  void crearMovimiento() async {
    if (_authRepository.usuario.uid.isEmpty ||
        paisOrigen.value.uid.isEmpty ||
        tipoMovimiento.value == 0 ||
        importe.value == 0) {
      mostrarAlerta(Get.context!, 'Seleccione el Pais de Origen',
          'Debe seleccionar un pais de Origen');
    } else {
      movimiento.value.idUsuario = _authRepository.usuario.uid;
      movimiento.value.idPais = paisOrigen.value.uid;
      movimiento.value.tipoIngreso = tipoMovimiento.value;
      movimiento.value.importe = importe.value;
      movimiento.value.cantidad = cantidad.value;
      http.Response resp = await repository.crearMovimiento(movimiento.value);
      if (resp.statusCode == 200) {
        await sample();
        // paisOrigen.value = paisDefault;
        // paisOrigenCtrl.value.text = '';
        // tipoMovimiento.value = 0;
        // importe.value = 0;
        Get.snackbar('Registro Correcto', 'Movimiento Ingresado correctamente');
        Get.toNamed(Routes.HOMEOPER);
      } else {
        await mostrarAlerta(Get.context!, 'Error de servidor',
            'Comuniquese con el Administrador ${resp.statusCode}');
        Get.offNamed(Routes.HOMEOPER);
      }
    }
  }

  Future<Uint8List> imagePathToUint8List(String path) async {
//converting to Uint8List to pass to printer

    ByteData data = await rootBundle.load(path);
    Uint8List imageBytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return imageBytes;
  }

  sample() async {
    final imageBytes = await imagePathToUint8List('assets/icono.png');
    final dateTime = DateTime.now();
    final fechaHora =
        "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
    NumberFormat f = NumberFormat("###.### Gs", "es_ES");
    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printImageBytes(imageBytes); //image from Asset
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "FECHA: $fechaHora", Size.bold.val, Align.left.val);
        bluetooth.printCustom("PAIS: ${paisOrigen.value.nombre.toUpperCase()}",
            Size.bold.val, Align.left.val);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "Importe abonado", Size.bold.val, Align.center.val);
        bluetooth.printCustom(
            f.format(importe.value), Size.extraLarge.val, Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printCustom(
            "Gracias por visitarnos", Size.medium.val, Align.center.val);
        bluetooth.printCustom(
            "VUELVA PRONTO", Size.boldMedium.val, Align.center.val);
        bluetooth.printQRcode("https://cti.itaipu.gov.py/es/node/342", 200, 200,
            Align.center.val);
        bluetooth.printNewLine();
        bluetooth.printNewLine();
        bluetooth.printNewLine();
      }
    });
  }

  void fchDesdeOnChange(DateTime fecha) {
    fchDesde.value = DateFormat("yyyy-MM-dd").format(fecha);
    fchDesdeCtrl.value.text = fchDesde.value;
  }

  void fchHastaOnChange(DateTime fecha) {
    fchHasta.value = DateFormat("yyyy-MM-dd").format(fecha);
    fchHastaCtrl.value.text = fchHasta.value;
  }

  void idUsuarioOnChange(Usuarios result) {
    idUsuario.value = result.uid;
    nombreUsuarioCtrl.value.text = result.nombre;
  }

  void obtenerResumen() async {
    http.Response resp = await repository.obtenerMovimientos(
        fchDesde.value, fchHasta.value, idUsuario.value);
    if (resp.statusCode == 200) {
      MovimientoResumenResponse movResumen =
          movimientoResumenResponseFromJson(resp.body);
      if (movResumen.ok) {
        resumen.value = movResumen.resumen;
        Get.toNamed(Routes.MOVIMIENTOSDETA);
      } else {
        await mostrarAlerta(Get.context!, 'Sin movimiento',
            'No se registra movimiento para la consulta');
        Get.back();
      }
    } else {
      await mostrarAlerta(Get.context!, 'Error',
          'Error al obtener detalle - hable con el administrador');
      Get.back();
    }
  }

  void obtenerDetalles() async {
    http.Response resp = await repository.obtenerMovimientosDet(
        fchDesde.value, fchHasta.value, idUsuario.value);
    if (resp.statusCode == 200) {
      MovimientoDetalleResponse movDetalle =
          movimientoDetalleResponseFromJson(resp.body);
      if (movDetalle.ok) {
        detalles.value = movDetalle.detalles;
       Get.toNamed(Routes.MOVIMIENTOSDETAPAGE);
      } else {
        await mostrarAlerta(Get.context!, 'Sin movimiento',
            'No se registra movimiento para la consulta');
        Get.back();
      }
    } else {
      await mostrarAlerta(Get.context!, 'Error',
          'Error al obtener detalle - hable con el administrador');
      Get.back();
    }
  }

  void chooseDate(void Function(DateTime text) fchOnChange, TipoFecha tipoFecha) async {
    DateTime? pickedDate = await material.showDatePicker(
        context: Get.context!,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2024));
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = tipoFecha==TipoFecha.FchDesde? 
                                        DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day, 0,0,0):
                                        DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day, 23,59,59);
      fchOnChange(selectedDate.value);
    }
  }

  void limpiarCamposConsulta() {
    fchDesde.value = "";
    fchHasta.value = "";
    idUsuario.value = "";
    fchDesdeCtrl.value.text = "";
    fchHastaCtrl.value.text = "";
    nombreUsuarioCtrl.value.text = "";
  }

  Future<Uint8List> crearReporte(Resumen resumen, String fchDesde,
      String fchHasta, String nombreUsuario) async {
    final pdf = pw.Document();
    final image =
        (await rootBundle.load("assets/icono2.png")).buffer.asUint8List();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(pw.MemoryImage(image),
                  width: 500, height: 150, fit: pw.BoxFit.cover),
              pw.SizedBox(height: 30),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [ pw.Text("RESUMEN DE MOVIMIENTOS", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30)),]),
              pw.SizedBox(height: 20),
              pw.Text("Fecha Desde: $fchDesde"),
              pw.SizedBox(height: 10),
              pw.Text("Fecha Hasta: $fchHasta"),
              pw.SizedBox(height: 10),
              pw.Text(
                  "Usuario: ${nombreUsuario == "" ? "TODOS" : nombreUsuario}"),
              pw.SizedBox(height: 30),
              pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                pw.Text(
                    "Movimientos Locales: ${resumen.cantMovLocal}  -  Importe: ${f.format(resumen.impMovLocal)}"),
                pw.SizedBox(height: 25),
                pw.Text(
                    "Movimientos Mercosur: ${resumen.cantMovMerc}  -  Importe: ${f.format(resumen.impMovMerc)}"),
                pw.SizedBox(height: 25),
                pw.Text(
                    "Movimientos No Mercosur: ${resumen.cantMovNoMerc}  -  Importe: ${f.format(resumen.impMovNoMerc)}"),
              ])),
              pw.SizedBox(height: 40),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
              pw.Text(
                  "Total: ${f.format(resumen.impMovLocal + resumen.impMovMerc + resumen.impMovNoMerc)}",
                  style: pw.TextStyle(
                      fontSize: 30, fontWeight: pw.FontWeight.bold)),
                      ])
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  // pw.Expanded itemColumn(List<Detalle> elements) {
  //   return pw.Expanded(
  //     child: pw.Column(
  //       children: [
  //         for (var element in elements)
  //           pw.Row(
  //             children: [
  //               pw.Expanded(
  //                   child: pw.Text(element.itemName,
  //                       textAlign: pw.TextAlign.left)),
  //               pw.Expanded(
  //                   child: pw.Text(element.itemPrice,
  //                       textAlign: pw.TextAlign.right)),
  //               pw.Expanded(
  //                   child:
  //                       pw.Text(element.amount, textAlign: pw.TextAlign.right)),
  //               pw.Expanded(
  //                   child:
  //                       pw.Text(element.total, textAlign: pw.TextAlign.right)),
  //               pw.Expanded(
  //                   child: pw.Text(element.vat, textAlign: pw.TextAlign.right)),
  //             ],
  //           )
  //       ],
  //     ),
  //   );
  // }

  Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getExternalStorageDirectory();
    var filePath = "${output?.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    //await OpenDocument.openDocument(filePath: filePath);
    final result = await OpenFile.open(filePath);
    print(result.message);

  }
}
