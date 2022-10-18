import 'dart:math';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_controller.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_detalle_request.dart';
import 'package:hito_app/app/routes/routes_app.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';

import '../../data/models/paises_model.dart';
import '../../ui/widgets/boton_azul.dart';
import '../../ui/widgets/custom_input.dart';

class MovimientosDetallePage extends GetView<MovimientosController> {
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
                      CustomLogo(
                        imagePath: 'assets/tag-logo3.png',
                      textLabel: 'Movimientos Detallados',
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
    final estilo = const TextStyle(fontWeight: FontWeight.bold, fontSize: 15);
    final DataTableSource _data = MyData(widget.movimientosController.detalles.value);
    return Container(
      //margin: EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Container(
          //color: Colors.green,
          // height: Get.height*0.2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text('Fecha Desde: ${widget.movimientosController.fchDesde.value}', style: estilo,),
                  Text('Fecha Hasta: ${widget.movimientosController.fchHasta.value}', style: estilo),
                  Text('Usuario: ${widget.movimientosController.nombreUsuarioCtrl.value.text==""?
                  "TODOS":widget.movimientosController.nombreUsuarioCtrl.value.text}', style: estilo),
                ],
              ),
              SizedBox(height: 20,),
              PaginatedDataTable(
                source: _data,
                columns: const [
                  DataColumn(label: Text('Num')),
                  DataColumn(label: Text('MovNum')),
                  DataColumn(label: Text('Fecha')),
                  DataColumn(label: Text('Cant')),
                  DataColumn(label: Text('Importe')),
                  DataColumn(label: Text('Pais')),
                  DataColumn(label: Text('Usuario')),
                ],
                //header: const Center(child: Text('My Products')),
                columnSpacing: 50,
                horizontalMargin: 60,
                rowsPerPage: 8,
              ),
              BotonAzul(
                  autenticando:
                      false, //widget.movimientosController.autenticando.value, //authService.autenticando,
                  texto: 'Generar PDF',
                  funcion: () async {
                    FocusScope.of(context).unfocus();
                    final data = await widget.movimientosController
                        .crearReporteDet(
                            widget.movimientosController.detalles,
                            widget.movimientosController.fchDesde.value,
                            widget.movimientosController.fchHasta.value,
                            widget.movimientosController.nombreUsuarioCtrl.value
                                .text);
                    final numale =
                        Random(DateTime.now().microsecond).nextInt(1000);

                    widget.movimientosController
                        .savePdfFile("reporte_$numale", data);
                    Get.offAllNamed(Routes.HOME);
                  }),
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
class MyData extends  DataTableSource{
  final List<Detalle> detalles;
  MyData(this.detalles);


  // final List<Map<String, dynamic>> _data = List.generate(
  //     200,
  //         (index) => {
  //       "id": index,
  //       "title": "Item $index",
  //       "price": Random().nextInt(10000)
  //     });

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(detalles[index].num.toString())),
      DataCell(Text(detalles[index].movNum.toString())),
      DataCell(Text(detalles[index].fecha)),
      DataCell(Text(detalles[index].cantidad.toString())),
      DataCell(Text(detalles[index].importe.toString())),
      DataCell(Text(detalles[index].pais)),
      DataCell(Text(detalles[index].usuario)),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => detalles.length;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}