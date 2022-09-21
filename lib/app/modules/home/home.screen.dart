import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hito_app/app/ui/widgets/boton_azul_nav.dart';
import 'package:hito_app/app/ui/widgets/custom_input.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';
import 'package:hito_app/app/ui/widgets/dialogo_turno.dart';

import '../../ui/widgets/custom_appbar.dart';
import 'controllers/home.controller.dart';

class HomeScreen extends GetView<HomeController> {
  HomeScreen({Key? key}) : super(key: key);
  DateTime timeBackPressed = DateTime.now();
  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Color(0xffF2F2F2),
          appBar: customAppBar('Home - Administrador',false),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
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
                      CustomLogo(
                        imagePath: 'assets/tag-logo.png',
                        textLabel: 'Hito Tres Fronteras\nPARAGUAY',
                      ),
                      Form(controller: controller/*, loadingCtrl: loadingCtrl*/),
                      SizedBox(height: 30,)
                    ],
                  ),
                ),
              ),
            ),
          )));
  }
}

class Form extends StatefulWidget {
  //final LoadingController loadingCtrl;
  //late bool? autenticado;
  final HomeController controller;
  const Form(
      {Key? key,
      //required this.loadingCtrl,
      //this.autenticado,
      required this.controller})
      : super(key: key);

  @override
  State<Form> createState() => _FormState();
}

class _FormState extends State<Form> {
  final idUsuarioController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  // TODO: implement widget
  Form get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    //_recLogged();
    return Container(
      //margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          BotonAzulNav(
              texto: 'Configuracion',
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.controller.goToSettings();
              }),
          SizedBox(height: 30,),
          BotonAzulNav(
              texto: 'Usuarios',
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.controller.goToUsers();
              }),
          SizedBox(height: 30,),
          BotonAzulNav(
              texto: 'Paises',
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.controller.goToPaises();
              }),
          SizedBox(height: 30,),
          BotonAzulNav(
              texto: 'Reportes',
              funcion: 
              () async {
                FocusScope.of(context).unfocus();
                widget.controller.goToReports();
              }
              )
        ],
      ),
    );
  }}