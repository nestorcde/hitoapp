// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/modules/login/login_controller.dart';
import 'package:hito_app/app/ui/widgets/boton_azul.dart';
import 'package:hito_app/app/ui/widgets/custom_input.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';
import 'package:hito_app/app/ui/widgets/label.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(builder: (_) {
      return Scaffold(
          backgroundColor: Color(0xffF2F2F2),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomLogo(
                        imagePath: 'assets/tag-logo3.png',
                        textLabel: '',
                      ),
                      Form(loginCtrl: _/*, loadingCtrl: loadingCtrl*/),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
            ),
          ));
    });
  }
}

class Form extends StatefulWidget {
  //final LoadingController loadingCtrl;
  //late bool? autenticado;
  final LoginController loginCtrl;
  const Form(
      {Key? key,
      //required this.loadingCtrl,
      //this.autenticado,
      required this.loginCtrl})
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
          CustomInput(
            icon: Icons.account_circle_outlined,
            enabled: true,
            placeholder: 'usuario',
            textController: idUsuarioController,
            keyboardType: TextInputType.text,
            onChanged: (value)  {
              widget.loginCtrl.idUsuarioOnChange(value);
            }
          ),
          SizedBox(height: 10,),
          CustomInput(
            icon: Icons.lock_outline,
            enabled: true,
            placeholder: 'contraseña',
            textController: passwordController,
            keyboardType: TextInputType.text,
            isPassword: true,
            onChanged: (value){
              widget.loginCtrl.pswOnChange(value);
            }
          ),
          SizedBox(height: 30,),
          Obx(() => BotonAzul(
              texto: 'Iniciar Sesion',
              autenticando: widget
                  .loginCtrl.autenticando.value, //authService.autenticando,
              funcion: () async {
                FocusScope.of(context).unfocus();
                widget.loginCtrl
                    .login();
              }))
        ],
      ),
    );
  }

  bool verificado() {
    if (idUsuarioController.text == '' || passwordController.text == '') {
      return false;
    }

    return true;
  }


  // Future<void> _recLogged() async {
  //   widget.autenticado = await widget.loadingCtrl.isLoggedIn();
  // }
}
