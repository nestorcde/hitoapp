import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomInput extends StatefulWidget {

  final IconData icon;
  final String placeholder;
  final TextEditingController? textController;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool enabled;
  final Function? onChanged;
  final TextStyle estilo;
  final TextAlign alineado;
  final bool denySpaces;



  const CustomInput({ 
    Key? key, 
    required this.icon, 
    required this.placeholder, 
    required this.enabled,
    this.textController, 
    this.keyboardType = TextInputType.text, 
    this.isPassword = false, 
    this.onChanged,
    this.estilo = const TextStyle(),
    this.alineado = TextAlign.start,
    this.denySpaces = false
  }) : super(key: key);


  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool noMostrarTexto = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noMostrarTexto = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    //bool noMostrarTexto = widget.isPassword;
    return Container(
      padding: const EdgeInsets.only(right: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5
          )
        ]
      ),
      child: TextFormField(
        textAlign: widget.alineado,
        autocorrect: false,
        keyboardType: widget.keyboardType,
        obscureText: noMostrarTexto,
        controller: widget.textController,
        enabled: widget.enabled,
        style: widget.estilo,
        inputFormatters: [
                if (widget.denySpaces)
                  FilteringTextInputFormatter.deny(
                      RegExp(r'\s')),
              ],
        decoration: InputDecoration(
          prefixIcon: Icon(widget.icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: widget.placeholder,
          labelText: widget.placeholder,
          suffixIcon: widget.isPassword?IconButton(
            onPressed: (){
              setState(() {
                noMostrarTexto = !noMostrarTexto;
              });
            }, 
            splashRadius: 5,
            icon:  Icon(noMostrarTexto ? Icons.visibility : Icons.visibility_off),
            alignment: Alignment.centerRight,
            ):const SizedBox()
        ),
        onChanged:(value) {
          widget.onChanged!(value);
        },
      ),
    );
  }
}