import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomLogo extends StatelessWidget {

  final String imagePath;
  final String textLabel;

  


  const CustomLogo({ 
    Key? key, 
    required this.imagePath, 
    required this.textLabel 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = Get.size.height;
    final width = Get.size.width;
    return Center(
      child: Container(
        width: width * 0.9,
        height: height * 0.20,
        margin: const EdgeInsets.only(top:20),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Flexible(
              flex: 1,
              child: Image(image: AssetImage(imagePath),width: width * 0.8,)),
            const SizedBox(height: 12,),
            Flexible(
              flex: 0,
              child: Text(textLabel, style: const TextStyle(fontSize: 18,), textAlign: TextAlign.center,))
          ],
        ),
      ),
    );
  }
}