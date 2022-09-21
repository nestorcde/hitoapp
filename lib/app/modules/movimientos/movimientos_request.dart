import 'dart:convert';

MovimientosRequest movimientoRequestFromJson(String str) => MovimientosRequest.fromJson(json.decode(str));

String movimientoRequestToJson(MovimientosRequest data) => json.encode(data.toJson());

class MovimientosRequest {
    MovimientosRequest({
        required this.idUsuario,
        required this.idPais,
        required this.tipoIngreso,
        required this.importe,
        required this.cantidad,
    });

    String idUsuario;
    String idPais;
    int tipoIngreso;
    int importe;
    int cantidad;

    factory MovimientosRequest.fromJson(Map<String, dynamic> json) => MovimientosRequest(
        idUsuario: json["idUsuario"],
        idPais: json["idPais"],
        tipoIngreso: json["tipoIngreso"],
        importe: json["importe"],
        cantidad: json["cantidad"],
    );

    Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "idPais": idPais,
        "tipoIngreso": tipoIngreso,
        "importe": importe,
        "cantidad": cantidad
    };
}
