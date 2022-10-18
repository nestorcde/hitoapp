import 'package:meta/meta.dart';
import 'dart:convert';

MovimientoRequest movimientoResponseFromJson(String str) => MovimientoRequest.fromJson(json.decode(str));

String movimientoResponseToJson(MovimientoRequest data) => json.encode(data.toJson());

class MovimientoRequest {
    MovimientoRequest({
        required this.ok,
        required this.msg,
        required this.fecha,
    });

    bool ok;
    String msg;
    DateTime fecha;

    factory MovimientoRequest.fromJson(Map<String, dynamic> json) => MovimientoRequest(
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
