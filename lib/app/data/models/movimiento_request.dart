import 'package:meta/meta.dart';
import 'dart:convert';

MovimientoResponse movimientoResponseFromJson(String str) => MovimientoResponse.fromJson(json.decode(str));

String movimientoResponseToJson(MovimientoResponse data) => json.encode(data.toJson());

class MovimientoResponse {
    MovimientoResponse({
        required this.ok,
        required this.msg,
        required this.fecha,
    });

    bool ok;
    String msg;
    DateTime fecha;

    factory MovimientoResponse.fromJson(Map<String, dynamic> json) => MovimientoResponse(
        ok: json["ok"],
        msg: json["msg"],
        fecha: DateTime.parse(json["fecha"]),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "fecha": fecha.toIso8601String(),
    };
}
