import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/paises_model.dart';
import 'package:hito_app/app/modules/paises/paises_controller.dart';
import 'package:hito_app/app/modules/settings/settings_controller.dart';
import 'package:hito_app/app/ui/widgets/boton_azul_nav.dart';
import 'package:hito_app/app/ui/widgets/custom_input.dart';
import 'package:hito_app/app/ui/widgets/custom_logo.dart';

import '../../ui/widgets/custom_appbar.dart';

class SettingsPage extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (_) {
        return FutureBuilder(
          future: _.getSettings(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return Scaffold(
                  backgroundColor: const Color(0xffF2F2F2),
                  appBar: customAppBar('Configuraciones', true),
                  body: SafeArea(
                    child: Container(
                      height: Get.size.height * 0.9,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          child: Container(
                            color: Colors.transparent,
                            //height: Get.size.height * 0.9,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const CustomLogo(
                                  imagePath: 'assets/tag-logo3.png',
                                  textLabel: '',
                                ),
                                Form(controller: _),
                                const SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }
}

class Form extends StatefulWidget {
  //final LoadingController loadingCtrl;
  //late bool? autenticado;
  final SettingsController controller;
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
  @override
  // TODO: implement widget
  Form get widget => super.widget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recargarPaises();
  }

  recargarPaises() async {
    widget.controller.listPaises =
        await widget.controller.paisesCtrl.getAllPaises();
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    //_recLogged();
    final ingSinImpCtrl = TextEditingController();
    ingSinImpCtrl.text = "Ingreso sin Impresora";
    return Container(
      //margin: EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Configuracion:',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => widget.controller.activarEdicion(),
                  icon: const Icon(Icons.edit),
                  tooltip: 'Editar Configuracion',
                )
              ],
            ),
          ),
          Obx(() => CustomInput(
                icon: Icons.monetization_on_outlined,
                placeholder: 'Precio Local',
                enabled: widget.controller.editPrecioLocal.value,
                onChanged: widget.controller.prLocalOnChanged,
                textController: widget.controller.prLocalCtrl.value,
                keyboardType: TextInputType.number,
              )),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => SizedBox(
                    width: Get.width * 0.45,
                    child: CustomInput(
                      icon: Icons.monetization_on_outlined,
                      placeholder: '+ Mercosur',
                      enabled: widget.controller.editPlusMerc.value,
                      onChanged: widget.controller.plMercOnChanged,
                      textController: widget.controller.plusMercCtrl.value,
                      keyboardType: TextInputType.number,
                    ),
                  )),
              Obx(() => SizedBox(
                    width: Get.width * 0.45,
                    child: CustomInput(
                      icon: Icons.monetization_on_outlined,
                      placeholder: '+ No Mercosur',
                      enabled: widget.controller.editPlusNoMerc.value,
                      onChanged: widget.controller.plNoMercOnChanged,
                      textController: widget.controller.plusNoMercCtrl.value,
                      keyboardType: TextInputType.number,
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => SizedBox(
                    width: Get.width * 0.45,
                    child: CustomInput(
                      icon: Icons.percent,
                      placeholder: 'Desc. Menores',
                      enabled: widget.controller.editDescMen.value,
                      onChanged: widget.controller.dsMenOnChanged,
                      textController: widget.controller.descMenoresCtrl.value,
                      keyboardType: TextInputType.number,
                    ),
                  )),
              Obx(() => SizedBox(
                    width: Get.width * 0.45,
                    child: CustomInput(
                      icon: Icons.percent,
                      placeholder: 'Desc. Adultos Mayores',
                      enabled: widget.controller.editDescMay.value,
                      onChanged: widget.controller.dsMayOnChanged,
                      textController: widget.controller.descMayoresCtrl.value,
                      keyboardType: TextInputType.number,
                    ),
                  )),
            ],
          ),
          Obx(() => CustomInput(
                icon: Icons.monetization_on_outlined,
                placeholder: 'Plus Fin de Semana',
                enabled: widget.controller.editPlusFinde.value,
                onChanged: widget.controller.plFindeOnChanged,
                textController: widget.controller.plusFindeCtrl.value,
                keyboardType: TextInputType.number,
              )),
          Obx(() => Visibility(
                visible: !widget.controller.editPaisLocal.value,
                child: Obx(() => CustomInput(
                      icon: Icons.monetization_on_outlined,
                      placeholder: 'Pais Local',
                      enabled: false,
                      onChanged: widget.controller.paisLocalOnChanged,
                      textController: widget.controller.paisLocalCtrl.value,
                      keyboardType: TextInputType.number,
                    )),
              )),
          Obx(() => Visibility(
                visible: widget.controller.editPaisLocal.value,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: Get.width * 0.75,
                      child: Obx(() => CustomInput(
                            icon: Icons.monetization_on_outlined,
                            placeholder: 'Pais Local',
                            enabled: false,
                            onChanged: widget.controller.paisLocalOnChanged,
                            textController:
                                widget.controller.paisLocalCtrl.value,
                            keyboardType: TextInputType.number,
                          )),
                    ),
                    Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: IconButton(
                          color: Colors.grey[600],
                          iconSize: 40,
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: CustomSearchDelegate(
                                    settingsController: widget.controller,
                                    paises: widget.controller.listPaises));
                          },
                        )),
                  ],
                ),
              )),
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: Get.width * 0.75,
                  child: CustomInput(
                    icon: Icons.monetization_on_outlined,
                    placeholder: 'Ingreso sin Impresora',
                    enabled: false,
                    //onChanged: widget.controller.paisLocalOnChanged,
                    textController: ingSinImpCtrl,
                    //keyboardType: TextInputType.number,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  child: Obx(() => Checkbox(
                        value: widget.controller.ingSinImp.value,
                        onChanged:!widget.controller.editIngSinImp.value? null: (value){
                          widget.controller.ingSinImp.value = value!;
                        },
                      )),
                ),
              ],
            ),
          ),
          Obx(() => Visibility(
                visible: widget.controller.editPaisLocal.value,
                child: BotonAzulNav(
                    texto: 'Guardar',
                    funcion: () async {
                      FocusScope.of(context).unfocus();
                      await widget.controller.workWithSettings();
                    }),
              )),
          Obx(() => Visibility(
                visible: !widget.controller.verBtnGuardar.value,
                child: const SizedBox(
                  height: 70,
                ),
              )),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  SettingsController settingsController;
  List<Paises> paises;
  CustomSearchDelegate(
      {required this.settingsController, required this.paises});

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
            settingsController.paisLocalOnChanged(result);
            close(context, null);
          },
        );
      },
    );
  }
}
