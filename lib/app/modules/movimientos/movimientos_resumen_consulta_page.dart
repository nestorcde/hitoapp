
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_controller.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';
import '../../ui/widgets/boton_azul.dart';
import '../../ui/widgets/custom_input.dart';

class MovimientosResumenConsultaPage extends GetView<MovimientosController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar('Consulta de Resumen', true),
        body: SafeArea(
          child: SizedBox(
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
                      textLabel: 'Consultar Resumen de Movimiento',
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
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.movimientosController.limpiarCamposConsulta();
  }


  @override
  Widget build(BuildContext context) {
    _recLoged();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            
                Container(
                  padding: EdgeInsets.only(top: 30),
                  width: Get.width * 0.75,
                  child: Obx(() => _crearFecha(
                      context,
                      widget.movimientosController.fchDesdeCtrl,
                      widget.movimientosController.fchDesdeOnChange,
                      'Fecha Desde:',
                      TipoFecha.FchDesde)),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: Get.width * 0.75,
                  child: Obx(() => _crearFecha(
                      context,
                      widget.movimientosController.fchHastaCtrl,
                      widget.movimientosController.fchHastaOnChange,
                      'Fecha Hasta:', TipoFecha.FchHasta)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10),
                  child: Row(
                    children: [
                      Obx(() => Container(
                        width: Get.width * 0.75,
                        child: CustomInput(
                          icon: Icons.account_circle_outlined,
                          placeholder: 'Usuario',
                          enabled: false,
                          onChanged: 
                              widget.movimientosController.idUsuarioOnChange,
                          textController:
                              widget.movimientosController.nombreUsuarioCtrl.value,
                        ),
                      )),
                      Container(
                          padding: const EdgeInsets.only(left: 10),
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
                                          .listaUsuarios));
                            },
                          )),
                    ],
                  ),
                ),
              
            BotonAzul(
              
                autenticando: widget.movimientosController.fchDesdeCtrl.value.text == "" 
                              || widget.movimientosController.fchHastaCtrl.value.text == "",
                texto: 'Finalizar',
                funcion: () async {
                  FocusScope.of(context).unfocus();
                  widget.movimientosController.obtenerResumen();
                })
          ],
        ),
      ),
    );
  }

  Future<void> _recLoged() async {
    //widget.autenticado = widget.movimientosController.isLoggedIn();
  }

  Widget _crearFecha(BuildContext context, Rx<TextEditingController> fchCtrl,
      void Function(DateTime text) fchOnChange, String texto, TipoFecha tipoFecha) {
    return TextField(
      controller: fchCtrl.value,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: texto,
          labelText: texto,
          prefixIcon: const Icon(Icons.calendar_today),
          //icon: const Icon(Icons.date_range)
          ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());

        widget.movimientosController.chooseDate(fchOnChange, tipoFecha);
      },
    );
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  MovimientosController movimientosController;
  List<Usuarios> paises;
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
    List<Usuarios> matchQuery = [];
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
    List<Usuarios> matchQuery = [];
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
            movimientosController.idUsuarioOnChange(result);
            close(context, null);
          },
        );
      },
    );
  }
}
