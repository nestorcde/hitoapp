import 'package:flutter/material.dart';
import 'package:get/get.dart';


class BotonAzulNav extends StatelessWidget {
  final String texto;
  final Function funcion;
  final bool enabled;
  const BotonAzulNav({ 
    Key? key, 
    required this.texto, 
    required this.funcion, 
    this.enabled = true, 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = Get.size.height;
    return ElevatedButton(
            
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 2,
              shape: const StadiumBorder()
            ),
            onPressed: enabled ? () => funcion() : null, 
            
            child: SizedBox(
              width: double.infinity,
              height: height * 0.08,
              child: Center(
                child: Text(
                    texto,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15
                    ),
                  )
              ),
            ));
  }
}