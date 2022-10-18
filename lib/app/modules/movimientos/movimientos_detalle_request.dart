
import 'dart:convert';

MovimientoDetalleResponse movimientoDetalleResponseFromJson(String str) => MovimientoDetalleResponse.fromJson(json.decode(str));

String movimientoDetalleResponseToJson(MovimientoDetalleResponse data) => json.encode(data.toJson());

class MovimientoDetalleResponse {
    MovimientoDetalleResponse({
        required this.ok,
        required this.msg,
        required this.detalles,
    });

    bool ok;
    String msg;
    List<Detalle> detalles;

    factory MovimientoDetalleResponse.fromJson(Map<String, dynamic> json) => MovimientoDetalleResponse(
        ok: json["ok"],
        msg: json["msg"],
        detalles: List<Detalle>.from(json["detalles"].map((x) => Detalle.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": msg,
        "detalles": List<dynamic>.from(detalles.map((x) => x.toJson())),
    };
}

class Detalle {
    Detalle({
        required this.num,
        required this.movNum,
        required this.fecha,
        required this.cantidad,
        required this.importe,
        required this.pais,
        required this.usuario,
    });

    int num;
    int movNum;
    String fecha;
    int cantidad;
    int importe;
    String pais;
    String usuario;

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        num: json["num"],
        movNum: json["movNum"],
        fecha: json["fecha"],
        cantidad: json["cantidad"],
        importe: json["importe"],
        pais: json["pais"],
        usuario: json["usuario"],
    );

    Map<String, dynamic> toJson() => {
        "num": num,
        "movNum": movNum,
        "fecha": fecha,
        "cantidad": cantidad,
        "importe": importe,
        "pais": pais,
        "usuario": usuario,
    };
}
