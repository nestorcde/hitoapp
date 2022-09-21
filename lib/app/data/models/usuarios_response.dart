// To parse this JSON data, do
//
//     final usuarioResponse = usuarioResponseFromJson(jsonString);

import 'dart:convert';

import 'package:hito_app/app/data/models/usuario_model.dart';

UsuarioResponse usuarioResponseFromJson(String str) => UsuarioResponse.fromJson(json.decode(str));

String usuarioResponseToJson(UsuarioResponse data) => json.encode(data.toJson());

class UsuarioResponse {
    UsuarioResponse({
        required this.ok,
        required this.usuarios,
    });

    bool ok;
    List<Usuarios> usuarios;

    factory UsuarioResponse.fromJson(Map<String, dynamic> json) => UsuarioResponse(
        ok: json["ok"],
        usuarios: List<Usuarios>.from(json["usuarios"].map((x) => Usuarios.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "usuarios": List<Usuarios>.from(usuarios.map((x) => x.toJson())),
    };
}


