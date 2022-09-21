import 'dart:math';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_controller.dart';
import 'package:hito_app/app/routes/routes_app.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';

import '../../data/models/paises_model.dart';
import '../../ui/widgets/boton_azul.dart';
import '../../ui/widgets/custom_input.dart';

class MovimientosResumenDetalle extends GetView<MovimientosController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar('Detalle de Movimientos', true),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                //height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomLogo(
                      imagePath: 'assets/tag-logo.png',
                      textLabel: 'Movimientos',
                    ),
                    _Form(movimientosController: controller),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  final MovimientosController movimientosController;
  //late bool? autenticado;
  _Form({
    Key? key,
    required this.movimientosController,
    /*this.autenticado*/
  }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  String tipoValue = "";

  @override
  // TODO: implement widget
  _Form get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    _recLoged();
    final estilo = TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
    return Container(
      //margin: EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Container(
          //color: Colors.green,
         // height: Get.height*0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 40,),
              Obx(() => Visibility(
                    visible:
                        widget.movimientosController.resumen.value.cantMovLocal >
                            0,
                    child: Obx(() => Text(
                        "Mov. Local: ${widget.movimientosController.resumen.value.cantMovLocal} "+
                        "- Importe: ${widget.movimientosController.f.format(widget.movimientosController.resumen.value.impMovLocal)}",
                        style: estilo,)),
                  )),
              SizedBox(height: 20,),
              Obx(() => Visibility(
                    visible:
                        widget.movimientosController.resumen.value.cantMovMerc >
                            0,
                    child: Obx(() => Text(
                        "Mov. Mercosur: ${widget.movimientosController.resumen.value.cantMovMerc} "+
                        "- Importe: ${widget.movimientosController.f.format(widget.movimientosController.resumen.value.impMovMerc)}",
                        style: estilo,)),
                  )),
              SizedBox(height: 20,),
              Obx(() => Visibility(
                    visible:
                        widget.movimientosController.resumen.value.cantMovNoMerc >
                            0,
                    child: Obx(() => Text(
                        "Mov. No Mercosur: ${widget.movimientosController.resumen.value.cantMovNoMerc} "+
                        "- Importe: ${widget.movimientosController.f.format(widget.movimientosController.resumen.value.impMovNoMerc)}",
                        style: estilo,)),
                  )),
              SizedBox(height: 20,),
              BotonAzul(
                  autenticando: widget.movimientosController.autenticando
                      .value, //authService.autenticando,
                  texto: 'Generar PDF',
                  funcion: () async {
                    FocusScope.of(context).unfocus();
                    final data = await widget.movimientosController.crearReporte(
                                      widget.movimientosController.resumen.value,
                                      widget.movimientosController.fchDesde.value,
                                      widget.movimientosController.fchHasta.value,
                                      widget.movimientosController.nombreUsuarioCtrl.value.text);
                    final numale = Random(DateTime.now().microsecond).nextInt(1000);

                    widget.movimientosController.savePdfFile("reporte_$numale", data);
                    Get.offAllNamed(Routes.HOME);

                  })
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _recLoged() async {
    //widget.autenticado = widget.movimientosController.isLoggedIn();
  }
}
