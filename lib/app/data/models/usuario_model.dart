class Usuarios {
    Usuarios({
        required this.idUsuario,
        required this.nombre,
        required this.tipo,
        required this.chPassword,
        required this.uid,
    });

    String idUsuario;
    String nombre;
    String tipo;
    bool   chPassword;
    String uid;

    factory Usuarios.fromJson(Map<String, dynamic> json) => Usuarios(
        idUsuario: json["idUsuario"],
        nombre: json["nombre"],
        tipo: json["tipo"],
        chPassword: json["chPassword"],
        uid: json["uid"],
    );

    Map<String, dynamic> toJson() => {
        "idUsuario": idUsuario,
        "nombre": nombre,
        "tipo": tipo,
        "chPassword": chPassword,
        "uid": uid,
    };
}
