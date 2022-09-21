import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hito_app/app/modules/loading/loading_page.dart';
import 'package:hito_app/app/routes/pages_app.dart';
import 'package:hito_app/app/ui/theme/theme_app.dart';
import 'package:hito_app/app/utils/dependency_injection.dart';

void main()async {
  await DependencyInjection.init();
  await initializeDateFormatting();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appThemeData,
        defaultTransition: Transition.fade,
        getPages: AppPages.pages,
        home: const LoadingPage(),
        ),
        
    
  );
}