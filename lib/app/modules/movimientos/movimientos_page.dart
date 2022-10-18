import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_controller.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';

import '../../data/models/paises_model.dart';
import '../../ui/widgets/boton_azul.dart';
import '../../ui/widgets/custom_input.dart';

class MovimientosPage extends GetView<MovimientosController> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: customAppBar('Movimientos', true),
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
                      imagePath: 'assets/tag-logo3.png',
                      textLabel: 'Registrar ingreso',
                    ),
                    SizedBox(height: 20,),
                    _Form(movimientosController: controller),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.add),
                onPressed: controller.paisOrigen.value.idPais > 0
                    ? controller.incrementar
                    : null),
                    SizedBox(height: 10,),
            Obx(() => FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.remove),
                onPressed: controller.cantidad.value > 1
                    ? (controller.paisOrigen.value.idPais > 0)
                        ? controller.decrementar
                        : (){}
                    : (){}))
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndFloat);
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
    // widget.movimientosController.cantidad.value = 1;
    // widget.movimientosController.cantidadCtrl.value.text = "1";
    _recLoged();
    return Container(
      //margin: EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => Visibility(
                  visible:
                      widget.movimientosController.tipoMovimiento.value == 1,
                  child: Obx(() => CustomInput(
                        icon: Icons.account_circle_outlined,
                        placeholder: 'Pais de Origen',
                        enabled: false,
                        onChanged:
                            widget.movimientosController.paisOrigeOnChange,
                        textController:
                            widget.movimientosController.paisOrigenCtrl.value,
                      )),
                )),
            Obx(() => Visibility(
                  visible:
                      widget.movimientosController.tipoMovimiento.value != 1,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * 0.75,
                        child: GestureDetector(
                          child: Obx(() => CustomInput(
                                icon: Icons.monetization_on_outlined,
                                placeholder: 'Pais de Origen',
                                enabled: false,
                                onChanged: widget
                                    .movimientosController.paisOrigeOnChange,
                                textController: widget
                                    .movimientosController.paisOrigenCtrl.value,
                              )),
                          onTap: () {
                            showSearch(
                                context: context,
                                delegate: _CustomSearchDelegate(
                                    movimientosController:
                                        widget.movimientosController,
                                    paises: widget
                                        .movimientosController.listaPaisesEx));
                          },
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            child: IconButton(
                              color: Colors.grey[600],
                              iconSize: 40,
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                showSearch(
                                    context: context,
                                    delegate: _CustomSearchDelegate(
                                        movimientosController:
                                            widget.movimientosController,
                                        paises: widget.movimientosController
                                            .listaPaisesEx));
                              },
                            ),
                          )),
                    ],
                  ),
                )),
            Row(
              children: [
                SizedBox(
                  width: Get.width * 0.75,
                  child: Obx(() => CustomInput(
                        estilo: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                        icon: Icons.monetization_on_outlined,
                        enabled: false,
                        placeholder:
                            widget.movimientosController.tipoMovimiento.value ==
                                    1
                                ? 'Importe Local'
                                : widget.movimientosController.tipoMovimiento
                                            .value ==
                                        2
                                    ? 'Importe Mercosur'
                                    : 'Importe No Mercosur',
                        textController:
                            widget.movimientosController.importeCtrl.value,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          //widget.registerCtrl.usrOnChange(value);
                        },
                      )),
                ),
                Obx(() => Container(
                      width: Get.width * 0.15,
                      height: Get.height * 0.09,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                offset: const Offset(0, 5),
                                blurRadius: 5)
                          ]),
                      child: TextField(
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                          controller:
                              widget.movimientosController.cantidadCtrl.value,
                          enabled: false,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                          )),
                    )),
              ],
            ),
            Obx(() => BotonAzul(
                autenticando: widget.movimientosController.connected.value?
                                false:
                                widget.movimientosController.settings.ingresoSinImpresora?
                                  false:true,
                texto: 'PAGAR',
                funcion: () async {
                  FocusScope.of(context).unfocus();
                  widget.movimientosController.crearMovimiento();
                }))
          ],
        ),
      ),
    );
  }

  Future<void> _recLoged() async {
    //widget.autenticado = widget.movimientosController.isLoggedIn();
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  MovimientosController movimientosController;
  List<Paises> paises;
  _CustomSearchDelegate(
      {required this.movimientosController, required this.paises});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query == '') {
              close(context, null);
            } else {
              query = '';
            }
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Paises> matchQuery = [];
    for (var pais in paises) {
      if (pais.nombre.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(pais);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.nombre),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Paises> matchQuery = [];
    for (var pais in paises) {
      if (pais.nombre.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(pais);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.nombre),
          onTap: () {
            movimientosController.paisOrigeOnChange(result);
            close(context, null);
          },
        );
      },
    );
  }
}
