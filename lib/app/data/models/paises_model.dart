class Paises {
    Paises({
        required this.idPais,
        required this.nombre,
        required this.mercosur,
        required this.uid,
    });

    int idPais;
    String nombre;
    bool mercosur;
    String uid = "";

    factory Paises.fromJson(Map<String, dynamic> json) => Paises(
        idPais: json["idPais"],
        nombre: json["nombre"],
        mercosur: json["mercosur"],
        uid: json["uid"] ?? json['_id'],
    );

    Map<String, dynamic> toJson() => {
        "idPais": idPais,
        "nombre": nombre,
        "mercosur": mercosur,
        "uid": uid,
    };
}
