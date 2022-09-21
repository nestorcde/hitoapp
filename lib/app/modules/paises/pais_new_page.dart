// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/modules/paises/paises_controller.dart';
import 'package:hito_app/app/ui/widgets/boton_azul.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/custom_input.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';

class PaisNewPage extends StatefulWidget {
  const PaisNewPage({Key? key}) : super(key: key);

  @override
  State<PaisNewPage> createState() => _PaisNewPageState();
}

class _PaisNewPageState extends State<PaisNewPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaisesController>(builder: (_) {
      _.idPaisSelected.value = 0;
      return Scaffold(
          appBar: customAppBar('Registro de Pais', true),
          backgroundColor: Color(0xffF2F2F2),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomLogo(
                      imagePath: 'assets/tag-logo.png',
                      textLabel: 'Registro de Pais',
                    ),
                    _Form(paisCtrl: _),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ));
    });
  }
}

class _Form extends StatefulWidget {
  final PaisesController paisCtrl;
  //late bool? autenticado;
  _Form({
    Key? key,
    required this.paisCtrl,
    /*this.autenticado*/
  }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  @override
  // TODO: implement widget
  _Form get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    widget.paisCtrl.vaciarControlesNewPais();
    _recLoged();
    return Container(
      //margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          Obx(() => CustomInput(
                icon: Icons.abc_outlined,
                enabled: true,
                placeholder: 'Nombre',
                textController: widget.paisCtrl.nombreCtrl.value,
                keyboardType: TextInputType.name,
                onChanged: (value) {
                  widget.paisCtrl.nombreCtrl.value.text = value;
                  //widget.paisCtrl.nombreOnChange(value);
                },
              )),
          SizedBox(
            height: 10,
          ),
          Row(
            children: const [
              Text(
                "Mercosur:",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          Obx(() => ListTile(
                title: const Text("SI"),
                leading: Radio<bool>(
                  value: true,
                  groupValue: widget.paisCtrl.mercosurSelected.value,
                  onChanged: (value) {
                    //setState(() {
                    widget.paisCtrl.mercosurSelected.value = value!;
                    //widget.paisCtrl.mercosurOnChange(value);
                    //});
                  },
                  toggleable: true,
                ),
              )),
          Obx(() => ListTile(
                title: const Text("NO"),
                leading: Radio<bool>(
                  value: false,
                  groupValue: widget.paisCtrl.mercosurSelected.value,
                  onChanged: (value) {
                    //setState(() {
                    widget.paisCtrl.mercosurSelected.value = value!;
                    //widget.paisCtrl.mercosurOnChange(value);
                    //});
                  },
                ),
              )),
          SizedBox(
            height: 10,
          ),
          BotonAzul(
              autenticando:
                  widget.paisCtrl.guardando.value, //authService.autenticando,
              texto: 'Cargar Pais',
              funcion: () async {
                FocusScope.of(context).unfocus();
                await widget.paisCtrl.guardarDatos();
                Get.back();
              })
        ],
      ),
    );
  }

  Future<void> _recLoged() async {
    //widget.autenticado = widget.loadingCtrl.isLoggedIn();
  }
}
