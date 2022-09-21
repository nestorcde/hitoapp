import 'package:hito_app/app/data/models/paises_model.dart';
import 'dart:convert';

PaisesRequest paisesRequestFromJson(String str) => PaisesRequest.fromJson(json.decode(str));

String paisesResponseToJson(PaisesRequest data) => json.encode(data.toJson());

class PaisesRequest {
    PaisesRequest({
        required this.ok,
        required this.msg,
        required this.paises,
    });

    bool ok;
    String msg;
    List<Paises> paises;

    factory PaisesRequest.fromJson(Map<String, dynamic> json) => PaisesRequest(
        ok: json["ok"],
        msg: json["msg"],
        paises: List<Paises>.from(json["paises"].map((x) => Paises.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "paises": List<dynamic>.from(paises.map((x) => x.toJson())),
    };
}

