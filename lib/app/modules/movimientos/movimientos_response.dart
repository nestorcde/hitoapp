
import 'dart:convert';

MovimientoResponse movimientoResponseFromJson(String str) => MovimientoResponse.fromJson(json.decode(str));

String movimientoResponseToJson(MovimientoResponse data) => json.encode(data.toJson());

class MovimientoResponse {
    MovimientoResponse({
        required this.ok,
        required this.msg,
        required this.movimiento,
    });

    bool ok;
    String msg;
    Movimiento movimiento;

    factory MovimientoResponse.fromJson(Map<String, dynamic> json) => MovimientoResponse(
        ok: json["ok"],
        msg: json["msg"],
        movimiento: Movimiento.fromJson(json["movimiento"]),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "movimiento": movimiento.toJson(),
    };
}

class Movimiento {
    Movimiento({
        required this.idMovimiento,
        required this.idUsuario,
        required this.idPais,
        required this.tipoIngreso,
        required this.importe,
        required this.fchHra,
        required this.cantidad,
        required this.id,
        required this.createdAt,
        required this.updatedAt,
    });

    int idMovimiento;
    String idUsuario;
    String idPais;
    int tipoIngreso;
    int importe;
    DateTime fchHra;
    int cantidad;
    String id;
    DateTime createdAt;
    DateTime updatedAt;

    factory Movimiento.fromJson(Map<String, dynamic> json) => Movimiento(
        idMovimiento: json["idMovimiento"],
        idUsuario: json["idUsuario"],
        idPais: json["idPais"],
        tipoIngreso: json["tipoIngreso"],
        importe: json["importe"],
        fchHra: DateTime.parse(json["fchHra"]),
        cantidad: json["cantidad"],
        id: json["_id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "idMovimiento": idMovimiento,
        "idUsuario": idUsuario,
        "idPais": idPais,
        "tipoIngreso": tipoIngreso,
        "importe": importe,
        "fchHra": fchHra.toIso8601String(),
        "cantidad": cantidad,
        "_id": id,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
