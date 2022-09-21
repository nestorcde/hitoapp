// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/modules/loading/loading_controller.dart';
import 'package:hito_app/app/modules/register/register_controller.dart';
import 'package:hito_app/app/ui/widgets/boton_azul.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';
import 'package:hito_app/app/ui/widgets/custom_input.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(builder: (_) {
      final LoadingController controller = Get.find<LoadingController>();
      return Scaffold(
        appBar: customAppBar('Registro de Usuario', true),
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
                      textLabel: 'Registro de Usuario',
                    ),
                    _Form(registerCtrl: _, loadingCtrl: controller),

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
  final LoadingController loadingCtrl;
  final RegisterController registerCtrl;
  //late bool? autenticado;
  _Form({
    Key? key,
    required this.loadingCtrl,
    required this.registerCtrl,
    /*this.autenticado*/
  }) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final idUsuarioCtrl = TextEditingController();
  final nombreController = TextEditingController();
  String tipoValue = "";

  @override
  // TODO: implement widget
  _Form get widget => super.widget;

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    _recLoged();
    return Container(
      //margin: EdgeInsets.only(top: 15),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.account_circle_outlined,
            enabled: true,
            placeholder: 'Usuario',
            textController: idUsuarioCtrl,
            keyboardType: TextInputType.text,
            onChanged: (value) {
              widget.registerCtrl.usrOnChange(value);
            },
            denySpaces: true,
          ),
          SizedBox(height: 10,),
          CustomInput(
            icon: Icons.abc_outlined,
            enabled: true,
            placeholder: 'Nombre',
            textController: nombreController,
            keyboardType: TextInputType.name,
            onChanged: (value) {
              widget.registerCtrl.nombreOnChange(value);
            },
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              Text("Tipo de Usuario:", style: TextStyle(fontSize: 18),),
            ],
          ),
          ListTile(
            title: const Text("Administrador"),
            leading: Radio<String>(
              value: "ADMIN",
              groupValue: tipoValue,
              onChanged: (value) {
                setState(() {
                  tipoValue = value!;
                  widget.registerCtrl.tipoOnChange(value);
                });
              },
              toggleable: true,
            ),
          ),
          ListTile(
            title: const Text("Operador"),
            leading: Radio<String>(
              value: "OPER",
              groupValue: tipoValue,
              onChanged: (value) {
                  setState(() {
                    tipoValue = value!;
                    widget.registerCtrl.tipoOnChange(value);
                  });
              },
            ),
          ),
          SizedBox(height: 10,),
          BotonAzul(
              autenticando: widget
                  .registerCtrl.autenticando.value, //authService.autenticando,
              texto: 'Crear Usuario',
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.registerCtrl.register();
              })
        ],
      ),
    );
  }

  Future<void> _recLoged() async {
    //widget.autenticado = widget.loadingCtrl.isLoggedIn();
  }
}
