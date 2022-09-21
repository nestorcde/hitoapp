import 'dart:convert';

MovimientoResumenResponse movimientoResumenResponseFromJson(String str) => MovimientoResumenResponse.fromJson(json.decode(str));

String movimientoResumenResponseToJson(MovimientoResumenResponse data) => json.encode(data.toJson());

class MovimientoResumenResponse {
    MovimientoResumenResponse({
        required this.ok,
        required this.msg,
        required this.resumen,
    });

    bool ok;
    String msg;
    Resumen resumen;

    factory MovimientoResumenResponse.fromJson(Map<String, dynamic> json) => MovimientoResumenResponse(
        ok: json["ok"],
        msg: json["msg"],
        resumen: Resumen.fromJson(json["resumen"]),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "resumen": resumen.toJson(),
    };
}

class Resumen {
    Resumen({
        required this.cantMovLocal,
        required this.impMovLocal,
        required this.cantMovMerc,
        required this.impMovMerc,
        required this.cantMovNoMerc,
        required this.impMovNoMerc,
    });

    int cantMovLocal;
    int impMovLocal;
    int cantMovMerc;
    int impMovMerc;
    int cantMovNoMerc;
    int impMovNoMerc;

    factory Resumen.fromJson(Map<String, dynamic> json) => Resumen(
        cantMovLocal: json["cantMovLocal"],
        impMovLocal: json["impMovLocal"],
        cantMovMerc: json["cantMovMerc"],
        impMovMerc: json["impMovMerc"],
        cantMovNoMerc: json["cantMovNoMerc"],
        impMovNoMerc: json["impMovNoMerc"],
    );

    Map<String, dynamic> toJson() => {
        "cantMovLocal": cantMovLocal,
        "impMovLocal": impMovLocal,
        "cantMovMerc": cantMovMerc,
        "impMovMerc": impMovMerc,
        "cantMovNoMerc": cantMovNoMerc,
        "impMovNoMerc": impMovNoMerc,
    };
}
