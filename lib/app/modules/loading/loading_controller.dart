import 'package:get/get.dart';
import 'package:hito_app/app/data/repository/remote/auth_repository.dart';
import 'package:hito_app/app/routes/routes_app.dart';
import 'package:hito_app/app/utils/constants.dart';

class LoadingController extends GetxController {

  final AuthRepository _repository = Get.find<AuthRepository>();

  //RxBool loggedIn = false.obs;
  //RxBool autenticando = false.obs;

  @override
  void onReady(){
    _init();
  }


  Future<void> _init()async{
      final bool isLogged = await _repository.isLoggedIn();
      if(isLogged){
       _repository.usuario.tipo=="ADMIN"?
          Get.offAllNamed(Routes.HOME):
          Get.offAllNamed(Routes.HOMEOPER);
        
      }else{
        Get.offAllNamed(Routes.LOGIN);
      }
  }

  //isLoggedIn() => _repository.isLoggedIn();
 
  

  
}