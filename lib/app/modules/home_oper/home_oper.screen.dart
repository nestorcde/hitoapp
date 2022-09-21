import 'dart:io';
import 'dart:ui';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hito_app/app/modules/movimientos/movimientos_controller.dart';
import 'package:hito_app/app/ui/widgets/boton_azul_nav.dart';
import 'package:hito_app/app/ui/widgets/custom_input.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';
import 'package:hito_app/app/ui/widgets/dialogo_turno.dart';
import 'package:hito_app/app/ui/widgets/mostrar_alerta.dart';
import 'package:toast/toast.dart';

import '../../ui/widgets/custom_appbar.dart';
import 'controllers/home_oper.controller.dart';

class HomeOperScreen extends GetView<HomeOperController> {
  HomeOperScreen({Key? key}) : super(key: key);
  DateTime timeBackPressed = DateTime.now();
  
  
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    if(!controller.movimientosController.connected.value)  controller.movimientosController.initPlatformState();
    return WillPopScope(
      onWillPop: () async{ 
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >=  Duration(seconds: 2);

        timeBackPressed  = DateTime.now();
        if(isExitWarning){
          return false;
        }else{
          await dialogoConsulta2('Cerrar', 'Desea cerrar la aplicacion?', 'SI', 'NO', exit);
          return false;
        }
        
       },
      child: Scaffold(
          backgroundColor: const Color(0xffF2F2F2),
          appBar: customAppBar('Home - Operador', false),
          body: SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.transparent,
            height: Get.size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CustomLogo(
                  imagePath: 'assets/tag-logo.png',
                  textLabel: 'Hito Tres Fronteras\nPARAGUAY',
                ),
                Form(controller: controller, movController: controller.movimientosController),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
          )),
    );
  }
  
  
}



class Form extends StatefulWidget {
  //final LoadingController loadingCtrl;
  //late bool? autenticado;
  final HomeOperController controller;
  final MovimientosController movController;
  const Form(
      {Key? key,
      //required this.loadingCtrl,
      //this.autenticado,
      required this.controller,
      required this.movController})
      : super(key: key);

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  @override
  // TODO: implement widget
  Form get widget => super.widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.movController.bluetooth = BlueThermalPrinter.instance;
    // widget.movController.initPlatformState();
    // if (!mounted) return;
    //  setState(() {});

    // if (widget.movController.isConnected == true) {
    //   widget.movController.connected.value = true;
    // }
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    //_recLogged();
    return Container(
      //margin: EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Obx(() => BotonAzulNav(
              texto: 'Conectar Impresora',
              enabled: !widget.movController.connected.value,
              funcion: () async {
                FocusScope.of(context).unfocus();
                showSearch(
                    context: context,
                    delegate: _CustomSearchDelegate(
                        movimientosController: widget.movController,
                        paises: widget.movController.devices,
                        conectar: _connect));
              })),
          const SizedBox(
            height: 30,
          ),
          Obx(() => BotonAzulNav(
              texto: 'Visitante Local',
              enabled: widget.movController.connected.value,
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.controller.goToMovLocal();
              })),
          const SizedBox(
            height: 30,
          ),
          Obx(() => BotonAzulNav(
              texto: 'Visitante Extranjero',
              enabled: widget.movController.connected.value,
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.controller.goToMovExtranjero();
              })),
        ],
      ),
    );
  }

  void _connect() {
    if (widget.movController.device != null) {
      widget.movController.bluetooth.isConnected.then((isConnected) {
        if (isConnected == false) {
          widget.movController.bluetooth
              .connect(widget.movController.device!)
              .catchError((error) {
            widget.movController.connected.value = false;
          });
          //widget.movController.connected.value = true;
        }
      });
    } else {
      Get.snackbar('Sin Dispositivo', 'No se selecciono dispositivo');
    }
  }

  void _disconnect() {
    widget.movController.bluetooth.disconnect();
    widget.movController.connected.value = false;
  }
}

class _CustomSearchDelegate extends SearchDelegate {
  MovimientosController movimientosController;
  List<BluetoothDevice> paises;
  Function conectar;
  _CustomSearchDelegate(
      {required this.movimientosController,
      required this.paises,
      required this.conectar});

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
    List<BluetoothDevice> matchQuery = [];
    for (var pais in paises) {
      if (pais.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(pais);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name!),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<BluetoothDevice> matchQuery = [];
    for (var pais in paises) {
      if (pais.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(pais);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result.name!),
          onTap: () {
            movimientosController.device = result;
            conectar();
            close(context, null);
          },
        );
      },
    );
  }
}
