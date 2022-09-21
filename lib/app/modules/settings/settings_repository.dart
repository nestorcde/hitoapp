
import 'package:get/get.dart';
import 'package:hito_app/app/modules/settings/settings_model.dart';
import 'package:hito_app/app/modules/settings/settings_provider.dart';

class SettingsRepository {

final SettingsProvider api = Get.find<SettingsProvider>();


Future getSettings(){
  return api.getSettings();
}

Future createSettings(Settings settings){
  return api.createSettings(settings);
}

Future updateSettings(Settings settings){
  return api.updateSettings(settings);
}
// getId(id){
//   return api.getId(id);
// }
// delete(id){
//   return api.delete(id);
// }
// edit(obj){
//   return api.edit( obj );
// }
// add(obj){
//     return api.add( obj );
// }

}