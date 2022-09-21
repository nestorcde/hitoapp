// To parse this JSON data, do
//
//     final paisRequest = paisRequestFromJson(jsonString);

import 'package:hito_app/app/data/models/paises_model.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

PaisRequest paisRequestFromJson(String str) => PaisRequest.fromJson(json.decode(str));

String paisRequestToJson(PaisRequest data) => json.encode(data.toJson());

class PaisRequest {
    PaisRequest({
        required this.ok,
        required this.msg,
        required this.paises,
    });

    bool ok;
    String msg;
    Paises paises;

    factory PaisRequest.fromJson(Map<String, dynamic> json) => PaisRequest(
        ok: json["ok"],
        msg: json["msg"],
        paises: Paises.fromJson(json["paises"]),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "paises": paises.toJson(),
    };
}
