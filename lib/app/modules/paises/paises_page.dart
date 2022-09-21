
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hito_app/app/data/models/paises_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hito_app/app/modules/paises/paises_controller.dart';
import 'package:hito_app/app/routes/routes_app.dart';
import 'package:hito_app/app/ui/widgets/custom_appbar.dart';

class PaisesPage extends StatefulWidget {
  const PaisesPage({Key? key}) : super(key: key);

  @override
  State<PaisesPage> createState() => _PaisesPageState();
}

class _PaisesPageState extends State<PaisesPage> {
  // final Paiseservice = new Paiseservice();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Paises> paises = [];
  late PaisesController paisesController;
  var indicador = 1;

  @override
  void initState() {
    paisesController = Get.find<PaisesController>();
    paisesController.cargarPaises();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    // final socketService = Provider.of<SocketService>(context);
    // final pais = authService.pais;
    return GetBuilder<PaisesController>(
      builder: (_) {
        
        return Scaffold(
            appBar: customAppBar('Paises',true),
            body: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                header: WaterDropHeader(
                  complete: Icon(
                    Icons.check,
                    color: Colors.blue[400],
                  ),
                  waterDropColor: Colors.blueAccent,
                ),
                onRefresh: () {
                  _.cargarPaises();
                  _refreshController.refreshCompleted();
                },
                child: _listViewPaises(_)
                // Obx(() {
                //   if (_socketProvider.usuarioConectado.value) {
                //     //_.cargarUsuarios();
                //     return _listViewPaises(_);
                //   } else {
                //     //_.cargarUsuarios();
                //     return _listViewPaises(_);
                //   }
                // }
                // )
              ),
              floatingActionButton: FloatingActionButton(
                  onPressed: () => Get.toNamed(Routes.PAIS_NEW),
                  tooltip: 'Agregar Pais',
                  child: const Icon(Icons.add),
                ),
            );
      },
    );
  }

  ListView _listViewPaises(PaisesController paisesController) {
    //paisesController.cargarUsuarios();
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (_, i) =>
            _paisessTile(paisesController.paises.value[i], paisesController),
        separatorBuilder: (_, i) => const Divider(),
        itemCount: paisesController.paises.value.length);
  }

  ListTile _paisessTile(Paises pais, PaisesController paisesController) {
    return ListTile(
      title: Text(pais.nombre),
      subtitle: pais.mercosur?const Text("Mercosur"):const Text("No Mercosur"),
      leading: CircleAvatar(
        child: Text("${pais.idPais}")
      ),
      onTap: () async {
        paisesController.paisSelected.value = pais;
        Get.toNamed(Routes.PAIS);
      },
    );
  }
}
