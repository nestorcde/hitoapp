// To parse this JSON data, do
//
//     final profileRequestModel = profileRequestModelFromJson(jsonString);

import 'package:hito_app/app/data/models/usuario_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ProfileResponseModel profileRequestModelFromJson(String str) => ProfileResponseModel.fromJson(json.decode(str));

String profileRequestModelToJson(ProfileResponseModel data) => json.encode(data.toJson());

class ProfileResponseModel {
    ProfileResponseModel({
        required this.ok,
        required this.msg,
        required this.usuarios,
    });

    bool ok;
    String msg;
    Usuarios usuarios;

    factory ProfileResponseModel.fromJson(Map<String, dynamic> json) => ProfileResponseModel(
        ok: json["ok"],
        msg: json["msg"],
        usuarios: Usuarios.fromJson(json["usuarios"]),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "usuarios": usuarios.toJson(),
    };
}
